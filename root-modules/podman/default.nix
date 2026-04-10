{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.rootModules.podman;
in {
  options.rootModules.podman = {
    enable = mkEnableOption "enable podman module (rootless support)";
   host = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "Usuario principal para agregar al grupo podman";
    };
  };
  
  config = mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      # Gestionado ahora por Home-Manager
      #oci-containers.backend = "podman";
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true; # Required for podman-compose/containers to talk to each other.
      };
    };

    # TODO: Modularize
    users.users.${cfg.host} = { # replace `<USERNAME>` with the actual username
      extraGroups = [
        "podman"
      ];
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      podman-compose
    ];
  };
}
