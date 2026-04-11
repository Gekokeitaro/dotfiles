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

    homeModules.podman.containers = {
      "llama-swap" = {
        image = "ghcr.io/mostlygeek/llama-swap:vulkan";
        autoStart = true;
        network = "pmnet";

        extraConfig = {
          Container = {
            AddDevice = "/dev/dri:/dev/dri";
            GroupAdd = "video";
          };
        };

        ports = [ "0.0.0.0:8080:8080" ];

        volumes = [
          "${modelsDir}:/models"
          "${configDir}/config.yaml:/app/config.yaml"
        ];
      };
    };
  };
}
