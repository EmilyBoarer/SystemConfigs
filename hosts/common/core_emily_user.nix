# Setup 'emily' user. This setup is common to all nixos hosts
{ pkgs, lib, ... }:
{
  # Set up home-manager for nixos system
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.emily = lib.mkDefault ../../home/emily;
  home-manager.backupFileExtension = "backup";

  # Configure nixvim at a system level
  programs.nixvim = ../../nixvim.nix;

  # Create the 'emily' user
  users.users.emily = {
    # Set password with `passwd`
    isNormalUser = true;
    description = "Emily";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      home-manager
    ];
  };
}
