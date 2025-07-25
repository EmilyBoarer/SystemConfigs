{ pkgs, ... }:
{
  # GDM: login screen
  # TODO: move dm/other parts to a common config for graphical hosts
  # Pre 25.11
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # As of 25.11 NB: kept here for when upgrade happens to switch to this instead of the above
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;

  # System packages necessary to provide the desktop environment only
  environment.systemPackages = with pkgs; [
    waybar
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    dunst
    libnotify
    kitty
    swww # wallpapers
    rofi-wayland
    pavucontrol
  ];

  # Hyprland / WM settings TODO check that these are all hyprland and none of these are actually something else:
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
