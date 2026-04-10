{ config, lib, ... }:
let
  baseDir = "${config.home.homeDirectory}/.local/share/n8n-starter";
  sharedDataDir = "${baseDir}/shared";
  modelsDataDir = "${baseDir}/models";
  koboldaiAdminDir = "${baseDir}/kobold-admin";
  envFile = "${baseDir}/n8n.env";
in {
  options.containers.n8n-starter = {
    enable = lib.mkEnableOption "Habilitar stack de n8n, postgres y koboldcpp";
  };

  config = lib.mkIf config.containers.n8n-starter.enable {
    modules.podman.enable = true;

    # ==========================================
    # CREACIÓN AUTOMÁTICA DE DIRECTORIOS (Rootless)
    # ==========================================
    # Para Home Manager usamos systemd.user.tmpfiles.rules
    systemd.user.tmpfiles.rules = [
      "d ${baseDir} 0755 - - - -"
      "d ${sharedDataDir} 0755 - - - -"
      "d ${modelsDataDir} 0755 - - - -"
      "d ${koboldaiAdminDir} 0755 - - - -"
      "f ${envFile} 0600 - - - -" 
    ];

    # ==========================================
    # AUTOMATIZACIÓN DE LA RED "nixmox"
    # ==========================================
    # En servicios user-level Quadlets o Podman nativo de HM:
    # Services.podman (actualmente no incluye mkOption directo para redes rootless automáticas)
    # Sin embargo podemos inyectarla temporalmente con preStart o Quadlets `.network`
    xdg.configFile."containers/systemd/nixmox.network".text = ''
      [Network]
      Label=nixmox
    '';
    # ==========================================
    # CONTENEDORES OCI (enrutados vía nuestro módulo)
    # ==========================================
    modules.podman.containers = {

      # 1. Base de datos PostgreSQL
      postgres = {
        image = "postgres:16-alpine";
        cmd = [ "-c" "shared_buffers=64MB" "-c" "work_mem=16MB" "-c" "maintenance_work_mem=32MB" ];
        extraOptions = [
          "--network=nixmox"
          "--health-cmd=pg_isready -h localhost -U $POSTGRES_USER -d $POSTGRES_DB"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=10"
        ];
        environmentFiles = [ envFile ];
        volumes = [
          # Storage is relative to rootless environment natively, or mapped to absolute host dirs
          "postgres_storage:/var/lib/postgresql/data"
        ];

        # 3. Aplicación Principal n8n
        n8n = {
          image = "n8nio/n8n:latest";
          environment = {
            NODE_OPTIONS = "--max-old-space-size=512";
            N8N_DEFAULT_BINARY_DATA_MODE = "filesystem";
            N8N_ENABLE_EXECUTE_COMMAND= "true";
            NODES_EXCLUDE = "[]";
            EXECUTIONS_DATA_SAVE_ON_SUCCESS = "none";
            EXECUTIONS_DATA_SAVE_ON_ERROR = "all";
            EXECUTIONS_DATA_PRUNE = "true";
            EXECUTIONS_DATA_MAX_AGE = "48";
          };
          extraOptions = [ "--network=nixmox" ];
          ports = [ "5678:5678" ];
          environmentFiles = [ envFile ];
          volumes = [
            "n8n_storage:/home/node/.n8n"
            "${sharedDataDir}:/data/shared"
          ];
          dependsOn = [ "postgres" ];
        };

        # 4. Qdrant (Base de datos de búsqueda vectorial profunda)
        qdrant = {
          image = "qdrant/qdrant";
          environment = {
            QDRANT__STORAGE__ON_DISK_PAYLOAD = "true";
          };
          extraOptions = [ "--network=nixmox" ];
          ports = [ "6333:6333" ];
          volumes = [
            "qdrant_storage:/qdrant/storage"
          ];
        };

        # 5. El Cerebro (KoboldCPP puro con aceleración Vulkan)
        koboldcpp = {
          image = "koboldai/koboldcpp:latest";
          autoStart = false;
          extraOptions = [ 
            "--network=nixmox" 
            # Vulkan utiliza obligatoriamente el renderizador directo
            "--device=/dev/dri:/dev/dri"
            "--group-add=video"
          ];
          environment = {
            KCPP_DONT_TUNNEL = "true";
            KCPP_ARGS = "--usevulkan 0 --host 0.0.0.0 --port 5001 --contextsize 32768 --admin --admindir /admindir --downloaddir /models --routermode --adminunloadtimeout 30 --nomodel";       
          };
          ports = [ "5001:5001" ];
          volumes = [
            "${modelsDataDir}:/models"
            "${koboldaiAdminDir}:/admindir"
          ];
        };
      };
    };
  };
}
