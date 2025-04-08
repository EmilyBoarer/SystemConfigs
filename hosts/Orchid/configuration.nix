# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../nixos # Include general NixOS config
      ./games.nix # Steam, nVidia graphics settings, controller/gamepad drivers etc..
      ./bluetooth.nix # Bluetooth, so can use wireless controllers
  ];

  # This needs to be enabled here (despite it being enabled by home-manager) since it should be system-wide. we just use home-manager to customise our user's zsh
  programs.zsh.enable = true;

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub = {
    minegrub-world-sel = {
      enable = true;
      customIcons = [{
        name = "nixos";
        lineTop = "Orchid - NixOS";
        lineBottom = "Spectator Mode, Cheats";
        customImg = builtins.path {
          path = ./nixos-logo.png;
          name = "nixos-img";
        };
      }];
    };
  };



  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    spotify
    google-chrome
    gimp
    rawtherapee

    waybar
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    dunst
    libnotify
    kitty
    swww # wallpapers
    rofi-wayland # TODO what is this one too?
    pavucontrol

    steam
    nvtop
  ];

}
