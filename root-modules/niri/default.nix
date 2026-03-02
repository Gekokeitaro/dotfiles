{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.rootModules.niri;
in {
  options.rootModules.niri = {
    enable = mkEnableOption "enable niri module";
  };
  
  config = mkIf cfg.enable {
    programs.niri.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];
  };
}
