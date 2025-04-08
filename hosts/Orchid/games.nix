# Config specific to gaming: Steam, nVidia drivers, controller/gamepad drivers, etc..

{ config, pkgs, ... }:{

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  # Controller/gamepad support:
  hardware.xpadneo.enable = true;
  hardware.xone.enable = true; # support for the xbox controller USB dongle ???

  # TODO: bluetooth controllers etc..

  # Configure Hardware settings to actually give decent performance when playing games.
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    forceFullCompositionPipeline = true; # Fixes tearing
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  # Enable OpenGL
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
    vaapiIntel
    vaapiVdpau
    vulkan-tools
    vulkan-validation-layers
  ];

  # hardware.opengl.driSupport = true; # No longer has any effect
  hardware.pulseaudio.support32Bit = true;
  boot.kernelParams = ["nvidia_drm.modeset=1"];

}
