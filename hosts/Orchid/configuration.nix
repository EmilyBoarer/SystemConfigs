# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, hostname, ... }:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./games.nix # Steam, nVidia graphics settings, controller/gamepad drivers etc..
    ./bluetooth.nix # Bluetooth, so can use wireless controllers
    ../common/boot_themes.nix
    ../common/gui.nix
  ];

  # Bootloader # TODO move to hw-config? (or similar if using disko?)
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  # Support to build fro rpis:
  # https://discourse.nixos.org/t/compile-to-raspberry-pi/24338/2
  boot.binfmt.emulatedSystems = ["aarch64-linux"];


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

  # Enable SSH so can remote into Orchid
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users.emily.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNtA6RJe0WsRGMmDzJzu5tbyEg0wCxLsjww1W/pTyiW/3PD5Czyv7tJrjJU/5m971qu+LWd/nN4Ce1KK6qOywsvOqBcixl+O5otxqsDLQ/jBSQLfbR5swCttBS+mBlvzNzdBitAUaNYSpbvdGWG6mwRoX6TMB3FRowrZYdUUvo/wcB2ijxA67b9bwxSkRvcv6xvbUjlTBBZcBf/9WIj+kd0tgiKG+w5hQJxeiadr9bDcBqzxteJJXL6wxB9puEWvhKQpu9CjmfuyQrcKr1FibFYihDXxWg/i14FBWOWWWx7djUGoal4i5sAZXOT6fzurSBG5Fv0kJHNVuQ/ewQr7bwL6qSAzSb5fO4K1FlP4vdS+GU9pg9byVdzxushCUX09pwNao6jg+nJq0caa4PeOviOZ1pWlkZeCXX2NOamk1q1emLaRV9XW/20DZtB57bQ1FfjmpfN3Hs1vnsSbYyUsI0X70I5IpPPFO2whmmXiRw59VHZ1yWjg9eiwFaUR864VE= emily@Firethorn"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    spotify
    google-chrome
    gimp
    rawtherapee

    steam
    nvtop

    nixfmt-rfc-style
  ];

}
