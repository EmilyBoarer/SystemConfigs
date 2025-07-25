# TODO move this, or split it out?
# This is a base configuration that all RPi NixOS hosts are expected to use.
# As such, this file configures the system to a basic functioning state,
# and it expects all applications/services will be installed via some parent file.
{
  pkgs,
  ...
}:
{
  # based on https://nix.dev/tutorials/nixos/installing-nixos-on-a-raspberry-pi

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ]; # is this desirable? TODO investiagte
    };
  };

  environment.systemPackages = with pkgs; [
    nano # Fallback editor
  ];

  # NB: User config handled by core_emily_user.nix (so not creating any users here)

  # Since we're running headless, we need to enable SSH and add any public keys we wish to access with:
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  users.users."emily".openssh.authorizedKeys.keys = [
    # TODO this key is just a temporary one - TODO sort a less device-tied solution
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNtA6RJe0WsRGMmDzJzu5tbyEg0wCxLsjww1W/pTyiW/3PD5Czyv7tJrjJU/5m971qu+LWd/nN4Ce1KK6qOywsvOqBcixl+O5otxqsDLQ/jBSQLfbR5swCttBS+mBlvzNzdBitAUaNYSpbvdGWG6mwRoX6TMB3FRowrZYdUUvo/wcB2ijxA67b9bwxSkRvcv6xvbUjlTBBZcBf/9WIj+kd0tgiKG+w5hQJxeiadr9bDcBqzxteJJXL6wxB9puEWvhKQpu9CjmfuyQrcKr1FibFYihDXxWg/i14FBWOWWWx7djUGoal4i5sAZXOT6fzurSBG5Fv0kJHNVuQ/ewQr7bwL6qSAzSb5fO4K1FlP4vdS+GU9pg9byVdzxushCUX09pwNao6jg+nJq0caa4PeOviOZ1pWlkZeCXX2NOamk1q1emLaRV9XW/20DZtB57bQ1FfjmpfN3Hs1vnsSbYyUsI0X70I5IpPPFO2whmmXiRw59VHZ1yWjg9eiwFaUR864VE= emily@Firethorn"
  ];

  hardware.enableRedistributableFirmware = true;
}
