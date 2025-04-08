# flake.nix
{
  description = "Flake for Emily's systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    
    minegrub-world-sel-theme.inputs.nixpkgs.follows = "nixpkgs";  
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    #Do not track nixpkgs for nixvim - as per nixvim FAQ
    #nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, minegrub-world-sel-theme, nixvim, ... }:
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
      defineHomeManagerOnlySystem = username: system: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { inherit system; };
        
        modules = [
            {
              ## Assume home directory location
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }

                ./home/${username}/home.nix
                # ./locale.nix # TODO create a home-locale.nix ??
		nixvim.homeManagerModules.nixvim
        ];
	
      };
    in {
      nixosConfigurations.Orchid   = defineNixosSystem "Orchid";
      homeConfigurations.emily     = defineHomeManagerOnlySystem "emily" "x86_64-linux";
      homeConfigurations.emiboa01  = defineHomeManagerOnlySystem "emiboa01" "x86_64-linux";
  };
}
