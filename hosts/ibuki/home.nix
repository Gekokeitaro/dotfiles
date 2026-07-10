{ config, pkgs, inputs, ... }:

{
  imports = [ 
    ../../modules
    #./../modules/foot
    inputs.nvf.homeManagerModules.default
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ibuki";
  home.homeDirectory = "/home/ibuki";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    atuin # Replaces `history` with SQLite DB
    ripgrep # Fast, improved grep
    fzf # Fuzzyfinder
    fd # fast alternative to find
    btop # resource monitor
    eza # Modern alternative to ls
    bat # Color + Formatted cat
    zoxide # Smart cd which learns
    impala # TUI for managing wifi
    bluetui # TUI for managing bluetooth
    swaybg # TODO: Unir a sway
    # linter
    vale
    vale-ls
    qutebrowser
    sxiv
  ];

  homeModules.opencode.enable = true;
  homeModules.waybar.enable = true;
  homeModules.lazygit.enable = true;
  homeModules.nvf = {
    enable = true;
    hostConfigPath = ./config/nvf;
  };
  homeModules.ghostty.enable = true;
  homeModules.foot.enable = true;
  homeModules.alacritty.enable = true;
  homeModules.tmux.enable = true;
  homeModules.sway.enable = true;
  homeModules.pico8 = {
    enable = true;
    binaryPath = "$HOME/.local/share/pico-8/pico8";
  };

  xdg.configFile."niri/config.kdl".source = ./niri-config.kdl;
  
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".pi/agent/models.json".force = true;
    ".pi/agent/models.json".text = ''
      {
        "providers": {
          "llama-swap": {
            "baseUrl": "http://192.168.18.108:8080/v1",
            "api": "openai-completions",
            "apiKey": "bleh",
            "models": [
              {
                "id": "gemma-4-12B-it-qat-UD-Q4_K_XL",
                "input": [ "text" ]
              },
              {
                "id": "gemma-4-E4B-it-qat-UD-Q4_K_XL",
                "input": [ "text" ]
              },
              {
                "id": "LFM2.5-8B-A1B-UD-Q4_K_XL",
                "input": [ "text" ]
              },
              {
                "id": "gpt-oss-20b-Q4_K_M",
                "input": [ "text" ]
              },
              {
                "id": "Mellum2-12B-A2.5B-Instruct-Q4_K_M",
                "input": [ "text" ]
              }
            ]
          }
        }
      }
    '';
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.npm.enable = true; # TODO testing. Modularize later.
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
}
