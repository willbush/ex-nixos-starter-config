{
  description = "An example of a configured misterio77/nix-starter-config for impermanence";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = inputs@{ nixpkgs, impermanence, home-manager, ... }: {
    nixosConfigurations = {
      blitzar = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Pass inputs into the NixOS module system
        specialArgs = { inherit inputs; };

        modules = [
          impermanence.nixosModules.impermanence
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.will = import ./home.nix;
          }
        ];
      };
    };
  };
}
