{ config, lib, ... }:

with lib;

let
  cfg = config.homeModules.nvf;
in {
  options.homeModules.nvf = {
    enable = mkEnableOption "enable nvf module";

    hostConfigPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Define la ruta donde están los config files del host para nvf
      '';
    };
  };

  config = mkIf cfg.enable (
    let
      # Importamos las configuraciones a través de `default.nix`
      # `default.nix` expone los attrset con sus valores de config.
      commonConfig = import ./config { inherit lib; };
      hostConfig = if cfg.hostConfigPath != null && builtins.pathExists cfg.hostConfigPath 
      then import "${cfg.hostConfigPath}" { inherit lib; } else {};
    in {
      programs.nvf = {
        enable = true;
        settings.vim = {
          viAlias = true;
          vimAlias = true;

          keymaps = ( commonConfig.keymaps or [] ) ++ ( hostConfig.keymaps or [] );
          autocmds = ( commonConfig.autocmds or [] ) ++ ( hostConfig.autocmds or [] );

          ui.noice.enable = true;
          ui.noice.setupOpts.messages.enable = true;

          diagnostics.enable = true;
          diagnostics.config.virtual_text = true;
          diagnostics.nvim-lint = mkIf ( 
            commonConfig ? linters_by_ft 
            || hostConfig ? linters_by_ft
          ) { 
              enable = true;
              linters_by_ft = ( commonConfig.linters_by_ft or {} ) 
                // ( hostConfig.linters_by_ft or {} );
            };

          theme = {
            enable = true;
            name = "catppuccin";
            style = "mocha";
            transparent = true;
          };

          visuals.indent-blankline.enable = true;
          highlight.LineNr = { fg = "#cdd6f4"; };
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

          filetree.neo-tree.enable = true;
          filetree.neo-tree.setupOpts.hijack_netrw_behaviour = "disabled"; 

          lsp.enable = true;
          lsp.trouble.enable = true;

          languages = { enableTreesitter = true; }
            // ( commonConfig.languages or {} ) // ( hostConfig.languages or {} );

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
    });
}
