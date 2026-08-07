{
  args,
  host-args,
  inputs,
}:
hostname:
let
  system = host-args."${hostname}".config-vars.system;
  specialArgs = inputs.nixpkgs.lib.recursiveUpdate args (
    inputs.nixpkgs.lib.recursiveUpdate host-args."${hostname}" {
      config-vars = {
        inherit hostname;
      };
      unstable = (
        import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }
      );
    }
  );
in
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = specialArgs;

  system = system;

  modules = [
    ./hosts/${hostname}/configuration.nix

    inputs.agenix.nixosModules.default
    inputs.stylix.nixosModules.stylix
    inputs.home-manager.nixosModules.home-manager

    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = specialArgs;
      home-manager.users."${args.config-vars.username}" = import ./hosts/${hostname}/home.nix;
    }
  ];
}
