{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.homeModules.nvf;
in {
  options.homeModules.nvf = {
    enable = mkEnableOption "enable nvf module";
  };

  config = mkIf cfg.enable {
    programs.nvf = {
      enable = true;
      settings.vim = {
        viAlias = true;
        vimAlias = true;

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        options = {
          tabstop = 2;
          shiftwidth = 0;
          autoindent = true;
        };

        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        filetree.neo-tree.enable = true;
        lsp.enable = true;

        languages = {
          enableTreesitter = true;
          
          nix.enable = true;
          markdown.enable = true;
        };
        
        snippets.luasnip = {
          enable = true;
          loaders = ''
            require("luasnip.loaders.from_lua").load({paths = { "${./snippets}"}})
          '';
          setupOpts = {
            enable_autoSnippets = true;
          };
        };
      };
    };
  };
}


