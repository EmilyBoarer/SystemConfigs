{
  pkgs,
  ...
}:
{
  # Minegrub bootloader theme:
  boot.loader.grub = {
    minegrub-world-sel = {
      enable = true;
      customIcons = [
        {
          name = "nixos";
          lineTop = "Orchid - NixOS";
          lineBottom = "Spectator Mode, Cheats";
          customImg = builtins.path {
            path = ./nixos-logo.png;
            name = "nixos-img";
          };
        }
      ];
    };
  };

  # Plymouth:
  boot = {
    plymouth = {
      enable = true;
      theme = "colorful_sliced";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "colorful_sliced" ];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
