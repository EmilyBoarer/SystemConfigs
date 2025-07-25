# Core config for ALL nixos hosts
{ ... }:
{
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "emily"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
}
