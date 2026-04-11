{ config, lib, ... }:

with lib;

let
  cfg = config.homeModules.podman;
in {
  options.homeModules.podman = {
    enable = mkEnableOption "Enable Home-Manager Podman configurations";

    containers = mkOption {
      type = types.attrsOf types.anything;
    };
  };

  config = mkIf cfg.enable {
    services.podman.enable = true;
    services.podman.containers = cfg.containers;
    services.podman.networks."pmnet" = {
      autoStart = true;
    };
  };
}
