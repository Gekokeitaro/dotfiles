{ config, pkgs, lib, ... }

{
  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    lua-language-server
    
    # Nix utils
    nil
    nixpkgs-fmt

    nodejs
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      nvim-treesitter
      nvim-lspconfig
    ];
  };
}


