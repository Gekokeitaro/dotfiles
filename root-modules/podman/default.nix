{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.rootModules.podman;
in {
  options.rootModules.podman = {
    enable = mkEnableOption "enable podman module";
  };
  
  config = mkIf cfg.enable {
    virtualisation = {
      containers.enable = true;
      oci-containers.backend = "podman";
      podman = {
        enable = true;
        autoPrune.enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };

    # TODO: Modularize
    users.users.nixmox = { # replace `<USERNAME>` with the actual username
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
