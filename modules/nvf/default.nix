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

        keymaps = [
          { mode = "n"; key = "<left>"; silent = true; action = "<cmd> echo 'Use h to move!!'<CR>"; }
          { mode = "n"; key = "<right>"; silent = true; action = "<cmd> echo 'Use l to move!!'<CR>"; }
          { mode = "n"; key = "<up>"; silent = true; action = "<cmd> echo 'Use k to move!!'<CR>"; }
          { mode = "n"; key = "<down>"; silent = true; action = "<cmd> echo 'Use j to move!!'<CR>"; }

          { mode = "n"; key = "<C-h>"; silent = true; action = "<C-w><C-h>"; desc = "Move focus to the left window"; }
          { mode = "n"; key = "<C-l>"; silent = true; action = "<C-w><C-l>"; desc = "Move focus to the right window"; }
          { mode = "n"; key = "<C-k>"; silent = true; action = "<C-w><C-k>"; desc = "Move focus to the up window"; }
          { mode = "n"; key = "<C-j>"; silent = true; action = "<C-w><C-j>"; desc = "Move focus to the down window"; }
        ];

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
          transparent = true;
        };

        lineNumberMode = "number";
        undoFile.enable = true;

        options = {
          tabstop = 2;
          shiftwidth = 0;
          autoindent = true;
          cmdheight = 0;
          termguicolors = true;
          mouse = "a";
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


