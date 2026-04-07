{ config, pkgs, ... }:

let

  # Por convención en NixOS, centralizamos los datos del contenedor en /var/lib/
  homelabBaseDir = "/var/lib/n8n-starter";
  sharedDataDir = "${homelabBaseDir}/shared";
  modelsDataDir = "${homelabBaseDir}/models";
  koboldaiAdminDir= "${homelabBaseDir}/kobold-admin";
  
  # Archivo donde guardarás los secretos de base de datos y n8n (POSTGRES_USER, N8N_ENCRYPTION_KEY, etc.)
  envFile = "${homelabBaseDir}/n8n.env";
in
{
  # ==========================================
  # MEJORA: CREACIÓN AUTOMÁTICA DE DIRECTORIOS
  # ==========================================
  systemd.tmpfiles.rules = [
    "d ${homelabBaseDir} 0755 root root -"
    "d ${sharedDataDir} 0755 root root -"
    "d ${modelsDataDir} 0755 root root -" # Creamos obligatoriamente la carpeta física de los modelos
    "d ${koboldaiAdminDir} 0755 root root -"
    "f ${envFile} 0600 root root -" 
  ];
  # ==========================================
  # AUTOMATIZACIÓN DE LA RED "nixmox"
  # ==========================================
  systemd.services."create-nixmox-network" = {
    description = "Create OCI network nixmox";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.podman ]; 
    script = ''
      ${pkgs.podman}/bin/podman network inspect nixmox >/dev/null 2>&1 || ${pkgs.podman}/bin/podman network create nixmox
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    before = builtins.map (name: "podman-${name}.service") (builtins.attrNames config.virtualisation.oci-containers.containers);
  };

  # ==========================================
  # CONTENEDORES OCI
  # ==========================================
  virtualisation.oci-containers.containers = {
    
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
        "postgres_storage:/var/lib/postgresql/data"
      ];
    };

    # 3. Aplicación Principal n8n
    n8n = {
      image = "n8nio/n8n:latest";
      environment = {
        NODE_OPTIONS = "--max-old-space-size=512";
        N8N_DEFAULT_BINARY_DATA_MODE = "filesystem";
        N8N_ENABLE_EXECUTE_COMMAND= "true";
        NODES_EXCLUDE = "[]";
        
        # === MODO HOMELAB HUMILDE ===
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
        # Vulkan utiliza obligatoriamente el renderizador directo, nunca el KFD
        "--device=/dev/dri:/dev/dri"
        "--group-add=video"
      ];
      environment = {
        KCPP_DONT_TUNNEL = "true";
        # Pasamos los comandos de Kobold usando la variable oficial para no romper el ejecutable base (CRUN)
        KCPP_ARGS = "--usevulkan 0 --host 0.0.0.0 --port 5001 --contextsize 32768 --admin --admindir /admindir --downloaddir /models --routermode --adminunloadtimeout 30 --nomodel";       
        # Una vez que poseas el archivo descargado en /var/lib/n8n-starter/models/, puedes 
        # añadir a KCPP_ARGS "--model /models/tu_modelo.gguf" quitando el param --nomodel
      };
      ports = [ "5001:5001" ];
      volumes = [
        "${modelsDataDir}:/models"
        "${koboldaiAdminDir}:/admindir"
      ];
    };
  };
}

