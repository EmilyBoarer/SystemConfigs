# flake.nix
{
  description = "Flake for Emily's systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    
    minegrub-world-sel-theme.inputs.nixpkgs.follows = "nixpkgs";  
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    #nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, minegrub-world-sel-theme, ... }:
    let
      defineNixosSystem = hostname: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	  ./locale.nix
	  ./hosts/${hostname}/configuration.nix
	  minegrub-world-sel-theme.nixosModules.default # TODO haven't been able to get this to work from Orchid/configuration.nix yet - give it another go!
	  ({ config, pkgs, lib, ... }: {
   	    networking.hostName = lib.mkDefault hostname;
	    networking.networkmanager.enable = true;

            users.users.emily = {
	      # Set password with `passwd`
	      isNormalUser = true;
	      description = "Emily";
	      extraGroups = [ "networkmanager" "wheel" "audio" ];
	      shell = pkgs.zsh;
	      packages = with pkgs; [
                home-manager
              ];
	    };

            nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
            nix.settings.trusted-users = [ "root" "emily" ];
	    system.stateVersion = "24.05";
	  })
	  home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.emily = ./home/emily;
	    home-manager.backupFileExtension = "backup";
          }
        ];
      };
    in {
      nixosConfigurations.Orchid = defineNixosSystem "Orchid";
  };
}
