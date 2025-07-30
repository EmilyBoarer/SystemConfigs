# Web Server for Boarer.net
# FUTURE: make more generic, so can be used for other situations?

{
  lib,
  config,
  pkgs,
  ...
}:
let
  updateScript = lib.getExe (
    pkgs.writeShellApplication {
      name = "update-boarer.net-www";
      runtimeInputs = [ pkgs.git ];
      text = "
# Clone the repo if it does not exist
if [ ! -d /var/www ]
then
  mkdir /var/www
fi
if [ ! -d /var/www/boarer.net/.git ]
then
  cd /var/www
  ssh-keyscan github.com >> ~/.ssh/known_hosts # non-interactively avoid fingerprint acceptance
  git clone ${config.boarer.net.trackingRemote}
fi

# Update the HEAD to point to whatever branch we're tracking
cd /var/www/boarer.net
git remote set-url origin ${config.boarer.net.trackingRemote}
git fetch origin ${config.boarer.net.trackingBranch}
git checkout origin/${config.boarer.net.trackingBranch}
      ";
    }
  );
in
{
  options = {
    boarer.net.doSSL = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable ACME / SSL (using Let's Encrypt) for nginx";
    };
    boarer.net.trackingBranch = lib.mkOption {
      type = lib.types.str;
      default = "main";
      example = "development";
      description = "The branch to track. Works in combination with trackingRemote";
    };
    boarer.net.trackingRemote = lib.mkOption {
      type = lib.types.str;
      default = "git@github.com:EmilyBoarer/boarer.net.git";
      description = "The remote address to obtain the www content from. Works in combination with trackingBranch.";
    };
  };
  config = {
    # Wiki: https://nixos.wiki/wiki/Nginx
    services.nginx = {
      enable = true;
      virtualHosts."192.168.1.147" = {
        # TODO swap out for a proper domain name
        #addSSL = config.boarer.net.doSSL;
        #enableACME = config.boarer.net.doSSL;
        locations."/".root = "/var/www/boarer.net";
      };
      # TODO: start mdbook for blog + forward socket here! (so appears as domain/thoughts)
    };
    networking.firewall.allowedTCPPorts = [ 80 ]; # TODO update when sorting SSL / ACME
    #security.acme = { # This is Let's encrypt certs. Enable & sort this when first attempting to config with doSSL=true!!!
    #  acceptTerms = true;
    #  defaults.email = "foo@bar.com";
    #};

    # Automatically update WWW content:
    # Wiki: https://nixos.wiki/wiki/Cron
    services.cron = {
      enable = true;
      systemCronJobs = [
        # Every 1 minute, run the script as root
        "* * * * *      root    ${updateScript}"
      ];
    };

    # TODO investigate sops-nix for the private key of the service account (currently github access needs manual configuration)
  };
}
