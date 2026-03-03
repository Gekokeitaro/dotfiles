{ config, lib, pkgs, ...}:

with lib;

let
  cfg = config.homeModules.waybar;
in {
  imports = [ ./config ];
  options.homeModules.waybar = {
    enable = mkEnableOption "enable waybar module";
  };
  
  config = mkIf cfg.enable {
    programs.waybar.enable = true;
  };
}
