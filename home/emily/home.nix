# Config for `emily` user, assuming home-manager standalone

{ config, pkgs, ... }:{
  imports = [
    ../cli
    ./git.nix
  ];

  # Install Kitty terminal emulator
  programs.kitty.enable = true;  

}
