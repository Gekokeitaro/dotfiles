{ config, lib, ... }:

with lib;

let
  cfg = config.homeModules.nvf;
in {
  options.homeModules.nvf = {
    enable = mkEnableOption "enable nvf module";

    hostConfigPath = mkOption {
      type = types.path;
      description = ''
        Define la ruta donde están los config files del host para nvf
      '';
    };
  };

  config = mkIf cfg.enable (
    let
      # Función para obtener los ficheros a partir del configPath
      commonConfig = import ./config { inherit lib; };
      hostConfig = import "${cfg.hostConfigPath}" { inherit lib; };
    in {
      programs.nvf = {
        enable = true;
        settings.vim = {
          viAlias = true;
          vimAlias = true;

          keymaps = ( commonConfig.keymaps or [] ) ++ ( hostConfig.keymaps or [] );
          autocmds = ( commonConfig.autocmds or [] ) ++ ( hostConfig.autocmds or [] );

          ui.noice = {
            enable = true;
            setupOpts.messages.enable = true;
          };


          diagnostics = {
            enable = true;
            nvim-lint = {
              enable = true;
              
              linters_by_ft = mkIf ( 
                commonConfig ? linters_by_ft 
                || hostConfig ? linters_by_ft 
              ) (
                ( commonConfig.linters_by_ft or {} )
                // ( hostConfig.linters_by_ft or {} )
              );
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

          visuals.indent-blankline.enable = true;

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

          statusline = {
            lualine = mkIf ( commonConfig ? lualine || hostConfig ? lualine ) ( 
              { enable = true; } 
              // ( commonConfig.lualine or {} ) 
              // ( hostConfig.lualine or {} )
            );
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

          spellcheck = mkIf (commonConfig ? spellcheck || hostConfig ? spellcheck) (
            { enable = true; }
            // ( commonConfig.spellcheck or {} )
            // (hostConfig.spellcheck or {} )
          );

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
    }
  );
}


