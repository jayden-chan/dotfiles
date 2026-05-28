{
  description = "System configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-llama.url = "github:nixos/nixpkgs?rev=29916453413845e54a65b8a1cf996842300cd299";
    crane.url = "github:ipetkov/crane";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix/release-25.11";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    guitar-midi-mapper.url = "git+ssh://git@git.jayden.codes/jayden/guitar-midi-mapper.git";
    guitar-midi-mapper.inputs.nixpkgs.follows = "nixpkgs";
    guitar-midi-mapper.inputs.crane.follows = "crane";

    notifications-dbus-mon.url = "git+ssh://git@git.jayden.codes/jayden/notifications-dbus-mon.git";
    notifications-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";
    notifications-dbus-mon.inputs.crane.follows = "crane";

    sensors-mon.url = "git+ssh://git@git.jayden.codes/jayden/sensors-mon.git";
    sensors-mon.inputs.nixpkgs.follows = "nixpkgs";
    sensors-mon.inputs.crane.follows = "crane";

    spotify-dbus-mon.url = "git+ssh://git@git.jayden.codes/jayden/spotify-dbus-mon.git";
    spotify-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";
    spotify-dbus-mon.inputs.crane.follows = "crane";

    git-check.url = "git+ssh://git@git.jayden.codes/jayden/git-check.git";
    git-check.inputs.nixpkgs.follows = "nixpkgs";
    git-check.inputs.crane.follows = "crane";

    prodge.url = "git+ssh://git@git.jayden.codes/jayden/prodge.git";
    prodge.inputs.nixpkgs.follows = "nixpkgs";

    weblogs.url = "git+ssh://git@git.jayden.codes/jayden/weblogs.git";
    weblogs.inputs.nixpkgs.follows = "nixpkgs";
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
          terminal = "alacritty";
          locale = "en_CA.UTF-8";
          theme = import ./theme.nix;
          ips = {
            opnsense = "10.118.254.1";
            homelab = "10.118.254.125";
          };
        };
      };

      host-args = {
        grace = {
          config-vars = {
            system = "x86_64-linux";
            timezone = "America/Edmonton";
            terminal-font-size = 12;
            vsync = false;
          };
        };

        swift = {
          config-vars = {
            system = "x86_64-linux";
            timezone = "America/Edmonton";
            terminal-font-size = 13.5;
            vsync = true;
          };
        };
      };

      system-inputs = {
        inherit nixpkgs;
        inherit agenix;
        inherit stylix;
        inherit home-manager;
        inherit args;
        inherit host-args;
      };
    in
    {
      nixosConfigurations = {
        grace = import ./make-system.nix system-inputs "grace";
        swift = import ./make-system.nix system-inputs "swift";
      };
    };
}
