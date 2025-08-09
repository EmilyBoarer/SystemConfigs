# Config for `emiboa01` user, assuming home-manager standalone

{ pkgs, lib, ... }:
{
  imports = [
    ../cli
    ./work-only-tools.nix
  ];

}
