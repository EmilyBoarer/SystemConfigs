# Config for `emiboa01` user, assuming home-manager standalone

{ config, pkgs, ... }:{
  imports = [
    ../cli
    ./git.nix
    ./work-only-tools.nix
  ];

}
