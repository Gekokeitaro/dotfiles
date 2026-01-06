{config, pkgs, lib,  ...}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 18;
      theme = "Aurora";
    };
  };
}

