{
  pkgs,
  unstable,
  config,
  config-vars,
  inputs,
  ...
}:

let
  nvidia-package =
    (
      (config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "565.77";
        sha256_64bit = "sha256-CnqnQsRrzzTXZpgkAtF7PbH9s7wbiTRNcM0SPByzFHw=";
        sha256_aarch64 = "sha256-LSAYUnhfnK3rcuPe1dixOwAujSof19kNOfdRHE7bToE=";
        openSha256 = "sha256-Fxo0t61KQDs71YA8u7arY+503wkAc1foaa51vi2Pl5I=";
        settingsSha256 = "sha256-VUetj3LlOSz/LB+DDfMCN34uA4bNTTpjDrb6C6Iwukk=";
        persistencedSha256 = "sha256-wnDjC099D8d9NJSp9D0CbsL+vfHXyJFYYgU3CwcqKww=";
      }).overrideAttrs
      (
        {
          version,
          preFixup ? "",
          ...
        }:
        {
          preFixup =
            preFixup
            + ''
              sed -i 's/\x85\xc0\x0f\x84\x9b\x00\x00\x00\x48/\x85\xc0\x90\x90\x90\x90\x90\x90\x48/g' $out/lib/libnvidia-fbc.so.${version}
            '';
        }
      )
    ).overrideAttrs
      (
        {
          version,
          preFixup ? "",
          ...
        }:
        {
          preFixup =
            preFixup
            + ''
              sed -i 's/\xe8\x15\x34\xfe\xff\x85\xc0\x41\x89\xc4/\xe8\x15\x34\xfe\xff\x29\xc0\x41\x89\xc4/g' $out/lib/libnvidia-encode.so.${version}
            '';
        }
      );
in
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
    ../../common/steam.nix
    ../../common/stylix-root.nix
    ../../common/stylix.nix
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

  # disable HDMI audio entirely
  boot.blacklistedKernelModules = [
    "snd_hda_codec_hdmi"
    "snd_hda_intel"
  ];

  networking.wireless.enable = false;

  environment.systemPackages = with pkgs; [
    borgbackup
    dbeaver-bin
    dive
    drm_info
    exiftool
    exiv2
    google-cloud-sdk
    kdenlive
    liquidctl
    mat2
    noise-repellent
    protontricks
    qrencode
    yq-go

    unstable.ansel
    unstable.ardour
    unstable.caffeine-ng
    unstable.hugin
    unstable.prismlauncher

    # make the NVIDIA X11 libraries available for gpu-screen-recorder
    (pkgs.runCommand "gpu-screen-recorder" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${unstable.gpu-screen-recorder}/bin/gpu-screen-recorder $out/bin/gpu-screen-recorder \
        --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
        --prefix LD_LIBRARY_PATH : ${nvidia-package}/lib
    '')

    # make the NVIDIA libraries available for sensors-mon
    (pkgs.runCommand "sensors-mon" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${
        inputs.sensors-mon.packages."${system}".default
      }/bin/sensors-mon $out/bin/sensors-mon \
        --prefix LD_LIBRARY_PATH : ${nvidia-package}/lib
    '')
  ];

  # this can't be placed into a devenv configuration because
  # it needs access to the system-wide NVIDIA package paths
  environment.sessionVariables = {
    CUDA_PATH = "${pkgs.cudatoolkit}";
    EXTRA_LDFLAGS = "-L/lib -L${nvidia-package}/lib";
  };

  programs.firejail.enable = true;

  # virt-manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ config-vars.username ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  networking.firewall = {
    enable = true;

    allowedUDPPortRanges = [
      # KDE Connect
      {
        from = 1714;
        to = 1764;
      }

      # Sunshine
      {
        from = 47998;
        to = 48000;
      }
      {
        from = 8000;
        to = 8010;
      }
    ];

    allowedTCPPortRanges = [
      # KDE Connect
      {
        from = 1714;
        to = 1764;
      }
    ];

    allowedUDPPorts = [ ];
    allowedTCPPorts = [
      # SSH
      32223

      # dev servers
      4334
      10097

      # Sunshine
      47984
      47989
      47990
      48010
    ];
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

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    package = nvidia-package;
    open = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = false;
  };

  # disable mouse acceleration
  services.libinput = {
    enable = true;
    mouse = {
      accelSpeed = "-0.15";
      accelProfile = "flat";
      middleEmulation = false;
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
    device = "${config-vars.ips.homelab}:/";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
    ];
  };

  # Epson scanner support
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
  };

  users.users."${config-vars.username}".extraGroups = [
    "lp"
    "scanner"
  ];
}
