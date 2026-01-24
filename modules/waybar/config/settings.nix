{ pkgs, ...}:

{
  programs.waybar.settings = {
    mainBar = {
      mode = "dock";
      position = "top";
      output = [ "eDP-1" ];

      modules-left = [
        "battery"
        "cpu"
        "memory"
        "disk"
      ];

      modules-center = [
        "niri/workspaces"
      ];

      modules-right = [
        "clock"
      ];

      "clock" = {
        format = "{:%H:%M}";
        timezone = "Europe/Madrid";
      };

      "niri/workspaces" = {
        format = "{name}";
        all-outputs = false;
        persistent-workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
        };
      };
    };
  };
}
