{ config-vars, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [ ];

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

  programs.nh = {
    enable = true;
    clean.enable = false;
    flake = "${config-vars.dotfiles-dir}/nix";
  };
}
