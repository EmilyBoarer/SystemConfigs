# Config to be used by all NixOS hosts

{ config, pkgs, ... }:{
  
  # Hyprland / WM settings
  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # TODO: Sort waybar here too!
  # Although, sorted now via home-manager??
}
