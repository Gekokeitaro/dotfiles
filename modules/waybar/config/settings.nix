{ pkgs, ...}:

{
  programs.waybar.settings = {
    mainBar = {
      mode = "dock";
      position = "top";
      output = [ "eDP-1" ];

      modules-left= [
        "niri/workspaces"
      ];

      modules-center= [
        "battery"
        "cpu"
        "memory"
        "disk"
        "temperature"
      ];
      
      modules-right = [
        "clock"
      ];

      "clock" = {
        format = "{:%H:%M}";
        timezone = "Europe/Madrid";
        interval = 60;
      };

      "battery" = {
        format = "<span foreground='#FFF1E8'>BAT\t<sup>{capacity}/100%</sup></span>";
	interval = 15;
        states = {
          "90" = 90;
          "82" = 82;
          "75" = 75;
          "62" = 62;
          "50" = 50;
          "44" = 44;
          "37" = 37;
          "25" = 25;
          "17" = 17;
          "10" = 10;
        };
      };

      "cpu" = {
        format = "<span foreground='#FFF1E8'>CPU\t<sup>{usage}/100%</sup></span>";
        interval = 10;
	states = {
          "90" = 90;
          "82" = 82;
          "75" = 75;
          "62" = 62;
          "50" = 50;
          "44" = 44;
          "37" = 37;
          "25" = 25;
          "17" = 17;
          "10" = 10;
        };
      };

      "memory" = {
        format = "<span fgcolor='#FFF1E8'>RAM\t<sup>{percentage}/100%</sup></span>";
        interval = 10;
        states = {
          "90" = 90;
          "82" = 82;
          "75" = 75;
          "62" = 62;
          "50" = 50;
          "44" = 44;
          "37" = 37;
          "25" = 25;
          "17" = 17;
          "10" = 10;
        };
      };

      "disk" = {
         format = "ENC\t<sup>{percentage_used}/100%</sup>";
         interval = 60;
       };

      "temperature" = {
        format = "TMP\t<sup>{temperatureC}</sup>";
        interval = 15;
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
