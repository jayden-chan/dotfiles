{
  description = "System configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    minichacha.url = "github:jayden-chan/minichacha";
    minichacha.inputs.nixpkgs.follows = "nixpkgs";

    spotify-dbus-mon.url = "github:jayden-chan/spotify-dbus-mon";
    spotify-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:jayden-chan/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      args = {
        inherit inputs;
        config-vars = {
          system = "x86_64-linux";
          name = "Jayden";
          username = "jayden";
          home-dir = "/home/jayden";
          dotfiles-dir = "/home/jayden/.config/dotfiles";
          locale = "en_CA.UTF-8";
        };
      };
    in
    {
      nixosConfigurations = {
        grace = nixpkgs.lib.nixosSystem {
          specialArgs = nixpkgs.lib.recursiveUpdate args {
            config-vars = {
              host = "grace";
              timezone = "America/Edmonton";
            };
          };

          system = args.config-vars.system;
          modules = [
            ./hosts/grace/configuration.nix

            stylix.nixosModules.stylix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = args;
              home-manager.users.jayden = import ./hosts/grace/home.nix;
            }
          ];
        };
      };
    };
}
