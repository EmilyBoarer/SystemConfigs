# Config for `emily` user, assuming NixOS system with home-manager

{ config, pkgs, ... }:{
  imports = [
    ../gui
    ./git.nix
  ];
}
