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

        ui.noice = {
          enable = true;
          setupOpts = {
            messages = {
              enable = true;
            };
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };

        options = {
          tabstop = 2;
          shiftwidth = 0;
          autoindent = true;
          cmdheight = 0;
        };

        statusline.lualine = {
          enable = true;
          
          componentSeparator = {};
          sectionSeparator = { 
            left = ""; 
            right = ""; 
          };

          activeSection = {
            a = [ '' {"mode", separator = { left = "" }, right_padding = 2 } '' ];
            b = [ '' "filename", "branch" '' ];
            c = [];
            x = [];
            y = [ '' "filetype", "progress" ''];
            z = [ '' { "location", separator = { right = "" }, left_padding = 2 } '' ];
          };

          inactiveSection = {
            a = [ '' "filename" '' ];
            b = [];
            c = [];
            x = [];
            y = [];
            z = [ '' "location" '' ];
          };
        };

        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
        filetree.neo-tree.enable = true;
        lsp.enable = true;

        languages = {
          enableTreesitter = true;
          
          nix.enable = true;
          markdown.enable = true;
          lua.enable = true;
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


