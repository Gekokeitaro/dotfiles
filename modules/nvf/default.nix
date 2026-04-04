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

        autocmds = [
          {
            desc = "Updates modified field in markdown YAML";
            pattern = [ "*.md" ];
            event = [ "BufWritePre" ];
            callback = lib.generators.mkLuaInline ''
              function(args)
                local bufnr = args.buf
                local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false)
                if lines[1] == "---" then
                  for i = 2, #lines do
                    if lines[i] == "---" then 
                      break
                    end
                    
                    if lines[i]:match("^modified:") then
                      local prefix = lines[i]:match("^(.-):")
                      local updated_time = os.date("%Y-%m-%dT%H:%M:%SZ")
                      vim.api.nvim_buf_set_lines(bufnr, i-1, i, false, { prefix .. ": " .. updated_time})
                      break
                    end
                  end
                end
              end
            '';
          }
        ];


        diagnostics = {
          enable = true;
          nvim-lint = {
            enable = true;
            linters_by_ft = {
              markdown = [ "vale" ];
              text = [ "vale" ];
            };
          };
          config = {
            virtual_text = true;
          };
        };

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        highlight = {
          LineNr = { fg = "#cdd6f4"; };
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
          cursorline = true;
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
        
        filetree.neo-tree = {
          enable = true;
          setupOpts = {
            hijack_netrw_behaviour = "disabled";
          };
        };

        lsp = {
          enable = true;
          trouble.enable = true;
        };

        languages = {
          enableTreesitter = true;

          nix.enable = true;
          
          html.enable = true;
          yaml.enable = true;
          markdown = {
            enable = true;
            extensions.render-markdown-nvim.enable = true;
          };

          lua.enable = true;
        };

        spellcheck = {
          enable = true;
          languages = [ "en" "es" ];
          programmingWordlist.enable = true;
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


