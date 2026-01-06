{config, pkgs, lib,  ...}:
{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 18;
      theme = "Aurora";
      window-decoration = false;

      # Transaparency
      background-opacity = 0.8;
      background-blur-radius = 20;
    };
  };
}

