{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ../../common/audio.nix
    ../../common/bluetooth.nix
    ../../common/bootloader.nix
    ../../common/env.nix
    ../../common/font.nix
    ../../common/general.nix
    ../../common/lecture.nix
    ../../common/nix-conf.nix
    ../../common/packages.nix
    ../../common/podman.nix
    ../../common/secrets.nix
    ../../common/stylix-root.nix
    ../../common/stylix.nix
    ../../common/thunar.nix
    ../../common/x.nix
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

  environment.systemPackages = [ ];
}
