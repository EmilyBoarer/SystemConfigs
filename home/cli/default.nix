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
    git
    tig
    lazygit
    tree
    #mosh SEE BELOW: have to make modification for it to work! why? how to fix properly?
    tmux
    bat
    ripgrep
    bottom
    (mosh.overrideAttrs(old: { # Mosh does not play nicely with LDAP users by default
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ makeWrapper ];
      # Work around "No user exists for uid <numbers>" by prepending sssd to
      # LD_LIBRARY_PATH This is a hack because it hijacks the
      # "postFixup", that incidentally is not set for mosh, but it could be in the future
      postPatch = ''
        substituteInPlace scripts/mosh.pl \
          --subst-var-by ssh "/usr/bin/ssh" \
          --subst-var-by mosh-client "$out/bin/mosh-client"
      '';
#        wrapProgram $out/bin/mosh --prefix LD_LIBRARY_PATH : "${sssd}/lib"
    }))
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
}
