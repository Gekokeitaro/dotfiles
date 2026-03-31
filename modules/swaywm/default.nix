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
        terminal = "foot -e tmux";
        defaultWorkspace = "workspace number 1";

        bars = [{
          position = "top";
          command = "waybar";
        }];
        
        keybindings = lib.mkOptionDefault {
          "Mod4+0" = "exec nyxt";
          "Mod4+9" = "exec kill";
          "Mod4+8" = "exec pico8";
          "Mod4+7" = "exec kill";
          "Mod4+6" = "exec kill";
        };
        window = {
          titlebar = false;
          border = 2;

          commands = [
            {
              command = ''move to workspace 5'';
              criteria = { app_id = "nyxt"; };
            }
            {
              command = ''move to workspace 4'';
              criteria = { class = "pico8"; };
            }
          ];
        };

        gaps = {
          inner = 4;
        };

        startup = [
          { command = "swaybg -i ~/.wallpapers/wallpaper.jpg -m --fill"; }
          { command = "foot -e tmux"; }
        ];
        
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
