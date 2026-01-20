{ pkgs, ...}:

{
  programs.waybar.settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;
      margin = "1px";
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
    };
  };
}
