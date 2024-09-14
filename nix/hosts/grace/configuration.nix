{
  config,
  pkgs,
  lib,
  config-vars,
  inputs,
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
    ../../common/thunar.nix
    ../../common/x.nix
  ];

  # do not change
  system.stateVersion = "24.05";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/2a32efbb-427b-49da-828b-72796dca93bb";
      preLVM = true;
    };
  };

  networking.hostName = "grace";
  networking.wireless.enable = false;

  users.users."${config-vars.username}".extraGroups = [
    "audio"
    "video"
    "input"
    "networkmanager"

    # Sudo
    "wheel"

    # Epson scanner support
    "lp"
    "scanner"
  ];

  # open ports in the firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      32223
      4334
    ];
    allowedUDPPorts = [ ];
  };

  services.openssh = {
    enable = true;
    ports = [ 32223 ];
    settings = {
      AllowUsers = [ config-vars.username ];
      PermitRootLogin = "no";
      X11Forwarding = true;
    };
  };

  services.flatpak.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # disable mouse acceleration
  services.libinput = {
    enable = true;
    mouse = {
      accelSpeed = "-0.25";
      accelProfile = "flat";
    };
  };

  services.udev.extraRules = ''
    # Aquacomputer Quadro allow access to non-root users
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c70", ATTRS{idProduct}=="f00d", TAG+="uaccess"

    # Disable motherboard bluetooth adapter
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0616", ATTR{authorized}="0"

    # Disable motherboard USB audio
    SUBSYSTEM=="usb", ATTRS{idVendor}=="0414", ATTRS{idProduct}=="a014", ATTR{authorized}="0"

    # Disable Scarlett Solo
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1235", ATTRS{idProduct}=="8211", ATTR{authorized}="0"

    # Sunshine input rules
    KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
  '';

  fileSystems."/mnt/homelab" = {
    device = "10.118.254.125:/";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
    ];
  };

  hardware.nvidia.modesetting.enable = true;

  # Epson scanner support
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
  };
}
