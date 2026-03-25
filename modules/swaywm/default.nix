{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.sway;
in {
  options.homeModules.sway = {
    enable = mkEnableOption "enable sway module";
  };
  
  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;

      package = pkgs.swayfx; 
      checkConfig = false;

      extraConfig = ''
        corner_radius 8
      '';

      config = {
        modifier = "Mod4";
        terminal = "foot";
        
        bars = [{
          position = "top";
          command = "waybar";
        }];
        
        window = {
          titlebar = false;
          border = 2;
        };

        gaps = {
          inner = 4;
        };

        input."*" = {
          xkb_layout = "es";
        };
        
        output."eDP-1" = {
          mode = "1920x1280@60Hz";
          scale = "2";
        };
      };        
    };
  };
}
