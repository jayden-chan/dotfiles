{
  description = "System configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    zen-browser.url = "github:MarceColl/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    minichacha.url = "github:jayden-chan/minichacha";
    minichacha.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      specialArgs = {
        inherit inputs;
        config-vars = {
          system = "x86_64-linux";
          name = "Jayden";
          username = "jayden";
          home-dir = "/home/jayden";
          timezone = "America/Edmonton";
          locale = "en_CA.UTF-8";
        };
      };
    in
    {
      nixosConfigurations = {
        grace = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = specialArgs.config-vars.system;
          modules = [
            ./hosts/grace/configuration.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = specialArgs;
              home-manager.users.jayden = import ./hosts/grace/home.nix;
            }
          ];
        };
      };
    };
}
