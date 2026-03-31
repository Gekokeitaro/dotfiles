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
    crawl
    crawlTiles
    atuin
    bulletty
    #bookokrat -> Flakes
    glow
    ripgrep
    fzf
    fd
    btop
    eza
    bat
    zoxide
    impala
    bluetui
    yazi
    lynx
    nyxt
    # linter
    vale
    vale-ls
  ];

  homeModules.opencode.enable = true;
  homeModules.waybar.enable = true;
  homeModules.lazygit.enable = true;
  homeModules.nvf.enable = true;
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
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  #services = {
  #  wpaperd = {
  #    enable = true;
  #    settings.eDP-1 = {
  #      path = ./wallpaper.jpg;
  #    };
  #  };
  #};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.
}
