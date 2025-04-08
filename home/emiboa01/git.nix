# Config for Git (personal)

{ config, pkgs, ... }:{
  programs.git = {
    enable = true;
    userName = "Emily Boarer";
    userEmail = "emily.boarer@arm.com";
  };
}
