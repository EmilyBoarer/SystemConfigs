# Config for Waybar

{ config, pkgs, ... }:{
  imports = [
  ];

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./style.css;
    settings = [{
      layer = "top";
      position = "top";
      mod = "dock";
      exclusive = true;
      passthrough = false;
      gtk-layer-shell = true;
      height = 0;
      modules-left = [
        "hyprland/workspaces"
	"clock"
      ];
      modules-center = [
        "hyprland/window"
      ];
      modules-right = [
	"pulseaudio"
        "tray"
	"bluetooth"
        "network"
      ];
      "hyprland/window" = { format = "{}"; };
      "wlr/workspaces" = {
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        all-outputs = true;
        on-click = "activate";
      };
      tray = {
        icon-size = 16;
        tooltip = false;
        spacing = 10;
      };
      clock = {
        format = "{:%I:%M %p}";
      };
      bluetooth = {
        on-click = "~/.config/waybar/scripts/rofi-bluetooth &"; # TODO populate with an actual script!
        format = " {status}";
      };
      pulseaudio = {
        #"scroll-step": 5,
        #"max-volume": 150,
        format = "vol {volume}%";
        #"format-bluetooth": "vol {volume}%",
        #"nospacing": 1,
        on-click = "pavucontrol";
        tooltip = false;
      };
    }];
  };
}
