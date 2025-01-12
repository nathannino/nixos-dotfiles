{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Latest stable branch of nixpkgs, used for version rollback
    # The current latest version is 23.11
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
	url = "github:nix-community/nixvim";
	# If using a stable channel, you can use `url = "github:nix-community/nixvim/nixos-<version>"
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs :
  let
    system = "x68_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-stable = nixpkgs-stable.legacyPackages.${system};
  in
  {
    nixosConfigurations = {
      nvidiadesktop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nvidiadesktop/configuration.nix
          inputs.home-manager.nixosModules.default
	  inputs.nixvim.nixosModules.nixvim
        ];
      };
      nixnathanlap = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nixnathanlap/configuration.nix
          inputs.home-manager.nixosModules.default
	  inputs.nixvim.nixosModules.nixvim
        ];
      };
    };
  };
}
