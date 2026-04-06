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

  programs.light.enable = true;
  programs.nm-applet.enable = true;

  networking.firewall = {
    enable = true;
    allowedUDPPortRanges = [ ];

    allowedTCPPortRanges = [ ];

    allowedUDPPorts = [ ];
    allowedTCPPorts = [ 4334 ];
  };

  fileSystems."homelab" = {
    device = "${config-vars.ips.homelab}:/";
    mountPoint = "/mnt/homelab";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
      "_netdev"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "x-systemd.mount-timeout=10"
    ];
  };

  environment.systemPackages = [ ];
}
