# Config for Window Manager & GUI things

{ config, pkgs, ... }:
{
  imports = [
    ../cli # Include CLI config too, this is an additional extension to that
    ./hypr
  ];

  programs.kitty = {
    enable = true;
    font = {
      name = "0xProto Nerd Font Propo";
      size = 16;
    };
    settings = {
      # Black
      color0 = "#000000";
      color8 = "#5e5e5e";
      # Red
      color1 = "#d60010";
      color9 = "#f66151";
      # Green
      color2 = "#43b911";
      color10 = "#33da7a";
      # Yellow
      color3 = "#ffba08";
      color11 = "#e9ad0c";
      # Blue
      color4 = "#2160ae";
      color12 = "#2a7bde";
      # Purple
      color5 = "#a21bc4";
      color13 = "#c061cb";
      # Cyan
      color6 = "#21b3c9";
      color14 = "#33c7de";
      # White
      color7 = "#9f9f9f";
      color15 = "#ffffff";
    };
  };
}
