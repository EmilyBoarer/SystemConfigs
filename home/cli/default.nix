# Config to be used by all systems: the CLI setup
# Basically, all the terminal tools & their configs

# home-manager CLI config:
{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./git.nix
  ];
  home.stateVersion = "24.05";
  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Terminal Tools:
    zsh
    nano
    wget
    htop
    btop
    neofetch
    tig
    tree
    mosh # This mosh is only good as the client side
    tmux
    bat
    ripgrep
    bottom
  ];

  # Configure Tools:

  #NB: Nixvim configured in [home.nix (hm) / core_emily_user.nix (nixos)]

  programs.zsh = {
    enable = true;
    history.size = 10000000;
    shellAliases = {
      amend = "git commit --amend";
      lg = "git log --oneline -n 15 --color=always | cat";
      gl = "lg";
      l = "ls -l";
      la = "ls -al";
      al = "la";
      grepr = "grep -r";
      gg = "git grep";
      #cat = "bat";
    };
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [ "git" ];
    };
    # TODO guard this for only systems that need it?  For user nix installation, this is required to get the shell to behave:
    #envExtra = ". /home/emiboa01/.nix-profile/etc/profile.d/nix.sh; export LANG=\"en_GB.UTF-8\"; export LOCALE_ARHCIVE=\"/usr/lib/locale/locale-archive\"; ";
    # This is required on work system? why?: envExtra = ". /home/emiboa01/.nix-profile/etc/profile.d/nix.sh; export LANG=\"en_GB.UTF-8\"; ";
    # Also, what's this doing again, and why is it needed? is there a better solution to generalise the environment setup on these systems?
    #home.sessionVariables = {
    #  LANG           = "en_GB.UTF-8";
    #  LOCALE_ARHCIVE = "/usr/lib/locale/locale-archive";
    #};
    # TODO finally sort out locales not working!
  };
  programs.tmux = {
    enable = true;
    mouse = true;
    historyLimit = 5000;
    shell = "${pkgs.zsh}/bin/zsh";
    clock24 = true;
    baseIndex = 1; # so numbers follow same order as on keyboard
  };
  home.sessionVariables = {
    SHELL = "zsh";
  };
}
