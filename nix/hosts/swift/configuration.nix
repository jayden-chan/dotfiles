{
  config,
  lib,
  pkgs,
  config-vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../common/index.nix
  ];

  # do not change
  system.stateVersion = "25.11";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/6b774b67-7acc-4865-a2ae-f70919cc6e16";
      preLVM = true;
    };
  };

  services.libinput.enable = true;
  networking.wireless.enable = false;

  programs.light.enable = true;
  programs.nm-applet.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPortRanges = [ ];
    allowedTCPPortRanges = [ ];
    allowedUDPPorts = [ ];
    allowedTCPPorts = [ 4334 ];
  };

  environment.systemPackages = [ ];
}
