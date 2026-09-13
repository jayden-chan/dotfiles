{
  description = "System configuration Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-cuda.url = "github:nixos/nixpkgs?rev=ed4942cb09ecfb6f7628166d9e041923c13bede6";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    crane.url = "github:ipetkov/crane";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-26.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    guitar-midi-mapper.url = "git+ssh://git@git.jayden.codes/jayden/guitar-midi-mapper.git";
    guitar-midi-mapper.inputs.nixpkgs.follows = "nixpkgs";
    guitar-midi-mapper.inputs.crane.follows = "crane";

    notifications-dbus-mon.url = "git+ssh://git@git.jayden.codes/jayden/notifications-dbus-mon.git";
    notifications-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";
    notifications-dbus-mon.inputs.crane.follows = "crane";

    prodge.url = "git+ssh://git@git.jayden.codes/jayden/prodge.git";
    prodge.inputs.nixpkgs.follows = "nixpkgs";
    prodge.inputs.crane.follows = "crane";

    sensors-mon.url = "git+ssh://git@git.jayden.codes/jayden/sensors-mon.git";
    sensors-mon.inputs.nixpkgs.follows = "nixpkgs";
    sensors-mon.inputs.crane.follows = "crane";

    spotify-dbus-mon.url = "git+ssh://git@git.jayden.codes/jayden/spotify-dbus-mon.git";
    spotify-dbus-mon.inputs.nixpkgs.follows = "nixpkgs";
    spotify-dbus-mon.inputs.crane.follows = "crane";

    git-check.url = "git+ssh://git@git.jayden.codes/jayden/git-check.git";
    git-check.inputs.nixpkgs.follows = "nixpkgs";
    git-check.inputs.crane.follows = "crane";

    mediaman.url = "git+ssh://git@git.jayden.codes/jayden/mediaman.git";
    mediaman.inputs.nixpkgs.follows = "nixpkgs";

    weblogs.url = "git+ssh://git@git.jayden.codes/jayden/weblogs.git";
    weblogs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { ... }@inputs:
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
        grace = rec {
          config-vars = {
            system = "x86_64-linux";
            timezone = "America/Edmonton";
            terminal-font-size = 12;
            vsync = false;
          };
          nixpkgs-cuda = (
            import inputs.nixpkgs-cuda {
              system = config-vars.system;
              config.allowUnfree = true;
              config.cudaSupport = true;
            }
          );
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
        inherit args;
        inherit host-args;
        inherit inputs;
      };
    in
    {
      nixosConfigurations = {
        grace = import ./make-system.nix system-inputs "grace";
        swift = import ./make-system.nix system-inputs "swift";
      };
    };
}
