{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.tmux;
in {
  options.homeModules.tmux= {
    enable = mkEnableOption "enable foot module";
  };
  
  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavor 'mocha'
            set -g @catppuccin_window_status_style 'rounded'
            # Mostrar app | basename
            set -g @catppuccin_window_default_text '#W | #{b:pane_current_path}'
            set -g @catppuccin_window_current_text '#W | #{b:pane_current_path}'
          '';
        }
      ];

      extraConfig = ''
        set -g status-position top
        set -g default-terminal 'tmux-256color'
      '';
    };
  };
}
