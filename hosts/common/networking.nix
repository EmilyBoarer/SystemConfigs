# Configure basic networking, common to nixos hosts
{ lib, hostname, ... }:
{
  networking.networkmanager.enable = true;
  networking.hostName = lib.mkDefault hostname;
}
