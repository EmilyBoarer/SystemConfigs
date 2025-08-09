# Generic Git configuration, for both work and personal usage

# main difference is:
# userEmail = "emily.boarer@arm.com";
# userEmail = "emily@boarer.uk";

# Both options should also be applied via home-manager on home-manager-only systems, and system wide on nixos hosts!

# use `git config --list --show-origin` to list current config, and sources in case of overriding configs

{ config, lib, ... }: {
  options = {
    gitEmail = lib.mkOption {
      type = lib.types.str;
      default = "emily@boarer.uk";
      example = "name@example.com";
      description = "The email address to use on this system for commit attribution";
    };
  };
  config = {
    programs.git = {
      enable = true;
      userName = "Emily Boarer";
      userEmail = config.gitEmail;
      ignores = [ ".direnv" ".envrc" ];
      extraConfig = {
        pull.rebase = true;
        init.defaultBranch = "main";
      };
# TODO signing.signByDefault = true; enable signing once PGP keys + yibikey sorted
    };
    programs.lazygit.enable = true; # TODO remove this from being declared elsewhere
  };
}
