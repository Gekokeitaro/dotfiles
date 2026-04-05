{ lib }:
{
  languages = {
    html.enable = true;
    yaml.enable = true;
    markdown = {
      enable = true;
      extensions.render-markdown-nvim.enable = true;
    };
  };
}
