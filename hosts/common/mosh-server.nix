# Add mosh system package for mosh server
# and configure necessary permissions

# This file currently assumes ssh and keys are already confgured
{ pkgs, ... }:{
  # Add server package to system:
  environment.systemPackages = with pkgs; [
    mosh
  ];
  # Open UDP port 60001
  networking.firewall.allowedUDPPorts = [ 60001 ];
}
