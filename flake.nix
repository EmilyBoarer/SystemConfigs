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

  outputs =
    {
      nixpkgs,
      home-manager,
      minegrub-world-sel-theme,
      nixvim,
      ...
    }:
    let
      defineNixosSystem =
        hostname:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit hostname; };
          modules = [
            ./locale.nix
            minegrub-world-sel-theme.nixosModules.default
            home-manager.nixosModules.home-manager
	    nixvim.nixosModules.nixvim
            ./hosts/common/core_nixos.nix
            ./hosts/common/core_emily_user.nix # sets up user & home-manager
            ./hosts/common/networking.nix
            ./hosts/${hostname}/configuration.nix
          ];
        };
      defineHomeManagerOnlySystem =
        username: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { inherit system; };
          modules = [
            {
              ## Assume home directory location
              home.username = username;
              home.homeDirectory = "/home/${username}";
            }
            ./home/${username}/home.nix
            nixvim.homeManagerModules.nixvim
          ];
        };
      defineRpiSystem = hostname: services: nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = { inherit hostname; };
        modules = [
          home-manager.nixosModules.home-manager
	  nixvim.nixosModules.nixvim
          ./hosts/common/core_nixos.nix
          ./hosts/common/core_emily_user.nix
          ./hosts/common/networking.nix
          ./hosts/common/rpi_configuration.nix
        ] ++ services;
      };
    in
    {
      # Orchid: Ryzen 9 3900X (24) @ 3.8 GHz - 32GB - GTX 1660
      nixosConfigurations.Orchid = defineNixosSystem "Orchid";

      # Firethorn: Framework 13 - i5-1135G7 (8) @ 4.200GHz - 32GB
      # Currently, home-manager on Ubuntu until flake is complete enough to switch to nixos
      homeConfigurations.emily = defineHomeManagerOnlySystem "emily" "x86_64-linux";

      # Work Systems (home-manager on Ubuntu):
      homeConfigurations.emiboa01 = defineHomeManagerOnlySystem "emiboa01" "x86_64-linux";

      # Experimenting with Raspberry Pi host support:
      # Snapdragon: RPi4B - Cortex A72 (4) @ 1.5GHz - 2GB
      nixosConfigurations.Snapdragon = defineRpiSystem "Snapdragon" [
        # Services will go here
      ];
      # This is running on just the SD card right now. TODO: can it run on some faster storage? USB SSD? even with remote building it just takes ages to write all the nix store
    };
}
