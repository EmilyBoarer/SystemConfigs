# Config for `emily` user, assuming home-manager standalone

{ pkgs, lib, ... }:
{
  imports = [
    ../cli
  ];

  # Install Kitty terminal emulator
  programs.kitty.enable = true;

}
