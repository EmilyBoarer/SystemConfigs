# Setup 'emily' user. This setup is common to all nixos hosts
{ pkgs, ... }:
{
  # Set up home-manager for nixos system
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.emily = ../../home/cli; ## TODO need to set back to home/emily - this is only desirable for rpi/headless
  home-manager.backupFileExtension = "backup";

  # Configure nixvim TODO: why does this not work when done through home-manager on a nixos system?
  programs.nixvim = ../../home/cli/nixvim.nix;

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
