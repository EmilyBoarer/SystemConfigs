# Config for `emily` user, assuming home-manager standalone

{ pkgs, lib, ... }:
{
  imports = [
    ../cli
    ./git.nix
  ];

  # Install Kitty terminal emulator
  programs.kitty.enable = true;

  programs.nixvim = import ../cli/nixvim.nix { inherit pkgs lib; };

}
