{
  nixpkgs,
  agenix,
  stylix,
  home-manager,
  args,
  host-args,
}:
hostname:
let
  system = host-args."${hostname}".config-vars.system;
  nixpkgs-config = {
    system = system;
    config.allowUnfree = true;
  };
  specialArgs = nixpkgs.lib.recursiveUpdate args (
    nixpkgs.lib.recursiveUpdate host-args."${hostname}" {
      unstable = import args.inputs.nixpkgs-unstable nixpkgs-config;
      config-vars = {
        inherit nixpkgs-config;
        inherit hostname;
      };
    }
  );
in
nixpkgs.lib.nixosSystem {
  specialArgs = specialArgs;

  system = system;

  modules = [
    ./hosts/${hostname}/configuration.nix

    agenix.nixosModules.default
    stylix.nixosModules.stylix
    home-manager.nixosModules.home-manager

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users."${args.config-vars.username}" = import ./hosts/${hostname}/home.nix;
    }
  ];
}
