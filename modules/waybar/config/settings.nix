{ pkgs, ...}:

{
  programs.waybar.settings = {
    mainBar = {
      mode = "dock";
      position = "top";
      output = [ "eDP-1" ];

      margin-top = 4;
      margin-left = 4;
      margin-bottom = 0;
      margin-right = 4;

      modules-left= [
        "battery"
        "cpu"
        "memory"
        "disk"
        "temperature"
      ];

      modules-center = [ "sway/workspaces" ];
      
      modules-right = [
        "clock"
      ];

      "sway/workspaces" = {
        format = "{icon}";
        on-click = "activate";
        format-icons = {
          "1" = "⚘";
          "2" = ".";
          "3" = "♣";
          "4" = "⧉";
          "5" = "⌬";
          "focused" = "@";
        };

        persistent-workspaces = {
          "1" = ["eDP-1"];
          "2" = ["eDP-1"];
          "3" = ["eDP-1"];
          "4" = ["eDP-1"];
          "5" = ["eDP-1"];
        };
      };

      "clock" = {
        format = "<span size='large'>{:%Y-%m-%d || %H:%M}</span>";
        timezone = "Europe/Madrid";
        interval = 60;
      };

      "battery" = {
        format = "<span size='large' foreground='#FFF1E8'>BAT <span rise='5pt' size='small'>{capacity}/100</span></span>";
	interval = 15;
        states = {
          "95" = 95;
          "90" = 90;
          "85" = 85;
          "80" = 80;
          "75" = 75;
          "70" = 70;
          "65" = 65;
          "60" = 60;
          "55" = 55;
          "50" = 50;
          "45" = 45;
          "40" = 40;
          "35" = 35;
          "30" = 30;
          "25" = 25;
          "20" = 20;
          "15" = 15;
          "10" = 10;
          "5" = 5;
          "0" = 0;
        };
      };

      "cpu" = {
        format = "<span size='large' foreground='#FFF1E8'>CPU <span rise='5pt' size='small'>{usage}/100</span></span>";
        interval = 10;
	states = {
          "95" = 95;
          "90" = 90;
          "85" = 85;
          "80" = 80;
          "75" = 75;
          "70" = 70;
          "65" = 65;
          "60" = 60;
          "55" = 55;
          "50" = 50;
          "45" = 45;
          "40" = 40;
          "35" = 35;
          "30" = 30;
          "25" = 25;
          "20" = 20;
          "15" = 15;
          "10" = 10;
          "5" = 5;
          "0" = 0;
        };
      };

      "memory" = {
        format = "<span size='large' fgcolor='#FFF1E8'>RAM <span rise='5pt' size='small'>{percentage}/100</span></span>";
        interval = 10;
        states = {
          "95" = 95;
          "90" = 90;
          "85" = 85;
          "80" = 80;
          "75" = 75;
          "70" = 70;
          "65" = 65;
          "60" = 60;
          "55" = 55;
          "50" = 50;
          "45" = 45;
          "40" = 40;
          "35" = 35;
          "30" = 30;
          "25" = 25;
          "20" = 20;
          "15" = 15;
          "10" = 10;
          "5" = 5;
          "0" = 0;
        };
      };

      "disk" = {
        format = "<span size='large' fgcolor='#FFF1E8'>ENC <span rise='5pt' size='small'>{percentage_used}/100</span></span>";
        interval = 60;
        states = {
          "95" = 95;
          "90" = 90;
          "85" = 85;
          "80" = 80;
          "75" = 75;
          "70" = 70;
          "65" = 65;
          "60" = 60;
          "55" = 55;
          "50" = 50;
          "45" = 45;
          "40" = 40;
          "35" = 35;
          "30" = 30;
          "25" = 25;
          "20" = 20;
          "15" = 15;
          "10" = 10;
          "5" = 5;
          "0" = 0;
        };
      };

      "temperature" = {
        format = "<span size='large'>TMP {temperatureC}º</span>";
        interval = 15;
      };
    };
  };
}
