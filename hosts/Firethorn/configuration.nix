## Firethorn System-specific configuration and choices

# TODOs:
# - Investigate disko for this system
# - try and keep this configuration very high level and not too verbose (add as many things to `common` as possible)
{ config, pkgs, lib, hostname, ... }:
{
  imports = [
    ../common/boot_themes.nix
    ../common/gui.nix
  ];

  # TODO add more things here!
}
