{
  description = "System configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-24.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    notifications-dbus-mon.url = "github:jayden-chan/notifications-dbus-mon";
    notifications-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";

    sensors-mon.url = "github:jayden-chan/sensors-mon";
    sensors-mon.inputs.nixpkgs.follows = "nixpkgs";

    spotify-dbus-mon.url = "github:jayden-chan/spotify-dbus-mon";
    spotify-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix,
      home-manager,
      stylix,
      ...
    }@inputs:
    let
      args = {
        inherit inputs;
        config-vars = rec {
          name = "Jayden";
          last-name = "Chan";
          username = "jayden";
          email = "jayden@jayden.codes";
          home-dir = "/home/jayden";
          dotfiles-dir = "${home-dir}/.config/dotfiles";
          terminal = "ghostty";
          locale = "en_CA.UTF-8";
          theme = import ./theme.nix;
          ips = {
            opnsense = "10.118.254.1";
            homelab = "10.118.254.125";
          };
        };
      };

      host-args = {
        grace = rec {
          config-vars = {
            host = "grace";
            system = "x86_64-linux";
            timezone = "America/Edmonton";
          };

          unstable = import inputs.nixpkgs-unstable {
            system = config-vars.system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              "electron-33.4.11"
            ];
          };
        };
      };
    in
    {
      nixosConfigurations = {
        grace = nixpkgs.lib.nixosSystem {
          specialArgs = nixpkgs.lib.recursiveUpdate args host-args.grace;

          system = host-args.grace.config-vars.system;

          modules = [
            ./hosts/grace/configuration.nix

            agenix.nixosModules.default
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = nixpkgs.lib.recursiveUpdate args host-args.grace;
              home-manager.users."${args.config-vars.username}" = import ./hosts/grace/home.nix;
            }
          ];
        };
      };
    };
}
