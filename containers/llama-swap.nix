{ config, lib, ... }:

  let
  # Directorio base para datos persistentes de llama-swap
  baseDir = "${config.home.homeDirectory}/.local/share/llama-swap";
  modelsDir = "${baseDir}/models";
  configDir = "${baseDir}/config";
in
  {
  options.containers.llama-swap = {
    enable = lib.mkEnableOption "Levantar contenedor de llama-swap";
  };

  config = lib.mkIf config.containers.llama-swap.enable {
    homeModules.podman.enable = true;

    # ==========================================
    # CREACIÓN AUTOMÁTICA DE DIRECTORIOS
    # ==========================================
    systemd.user.tmpfiles.rules = [
      "d ${baseDir} 0755 - - - -"
      "d ${modelsDir} 0755 - - - -"
      "d ${configDir} 0755 - - - -"
    ];

    xdg.configFile."containers/systemd/nixmox.network".text = ''
      [Network]
      Label=nixmox
    '';
    # ==========================================
    # CONTENEDOR: llama-swap (ROCm)
    # ==========================================
    # Documentación: https://github.com/mostlygeek/llama-swap
    # Imagen ROCm para aceleración AMD GPU
    #
    # IMPORTANTE: Antes de iniciar el contenedor, crea tu config.yaml:
    #   /var/lib/llama-swap/config/config.yaml
    #
    # Ejemplo mínimo de config.yaml:
    #   models:
    #     mi-modelo:
    #       cmd: llama-server --port ${PORT} --model /models/tu_modelo.gguf --gpu-layers 99
    #
    # Coloca tus modelos GGUF en:
    #   /var/lib/llama-swap/models/
    #
    # La interfaz web estará disponible en:
    #   http://localhost:8080/ui
      homeModules.podman.containers = {
      "llama-swap" = {
        image = "ghcr.io/mostlygeek/llama-swap:vulkan";
        autoStart = true;

        extraConfig = {
          Container = {
            Network = "nixmox";
            # Acceso al renderizador DRI (AMD iGPU)
            AddDevice = "/dev/dri:/dev/dri";
            GroupAdd = "video";
          };
        };

        ports = [ "8080:8080" ];

        volumes = [
          "${modelsDir}:/models"
          "${configDir}/config.yaml:/app/config.yaml"
        ];
      };
    };
  };
}
