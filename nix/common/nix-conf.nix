{ config-vars, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    trusted-users = [
      "root"
      config-vars.username
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
