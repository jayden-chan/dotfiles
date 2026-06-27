{
  pkgs,
  lib,
  config,
  config-vars,
  llama,
  inputs,
  ...
}:

let
  ssh-port = 32223;
  nvidia-package = (
    (config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "595.71.05";
      sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
      sha256_aarch64 = "sha256-XzKloS00dFKTd4ATWkTIhm9eG/OzR/Sim6MboNZWPu8=";
      openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
      settingsSha256 = "sha256-mXnf3jyvznfB3OfKd657rxv0rYHQb/dX/Riw/+N9EKU=";
      persistencedSha256 = "sha256-Z/6IvEEa/XfZ5F5qoSIPvXJLGtscYVqjFxHZaN/M2Ts=";
    }).overrideAttrs
      (
        {
          version,
          preFixup ? "",
          ...
        }:
        {
          preFixup = preFixup + ''
            sed -i 's/\x85\xc0\x0f\x85\xd4\x00\x00\x00\x48/\x85\xc0\x90\x90\x90\x90\x90\x90\x48/g' $out/lib/libnvidia-fbc.so.${version}
            sed -i 's/\xe8\x51\x21\xfe\xff\x41\x89\xc6\x85\xc0/\xe8\x51\x21\xfe\xff\x29\xc0\x41\x89\xc6/g' $out/lib/libnvidia-encode.so.${version}
          '';
        }
      )
  );
in
{
  imports = [
    ./hardware-configuration.nix
    ../../common/index.nix
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

  environment.systemPackages = with pkgs; [
    ansel
    ardour
    borgbackup
    caffeine-ng
    discordchatexporter-cli
    dive
    drm_info
    exiftool
    exiv2
    fritzing
    google-cloud-sdk
    hugin
    kdePackages.kdenlive
    liquidctl
    mat2
    mcaselector
    noise-repellent
    numlockx
    opencode
    openscad-unstable
    orca-slicer
    p7zip
    prismlauncher
    protontricks
    qrencode
    sqlite-interactive
    v4l-utils

    hidapi
    (yarg.overrideAttrs {
      version = "0.15.0";
      src = fetchzip {
        url = "https://github.com/YARC-Official/YARG/releases/download/v0.15.0/YARG_v0.15.0-Linux-x86_64.zip";
        stripRoot = false;
        hash = "sha256-xIWiQe0GSt6S9j2Xte/p+FHuO07Tv69zxS+OdNEI1sI=";
      };
    })

    llama

    inputs.guitar-midi-mapper.packages."${stdenv.hostPlatform.system}".default

    # make the NVIDIA X11 libraries available for gpu-screen-recorder
    (pkgs.runCommand "gpu-screen-recorder" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.gpu-screen-recorder}/bin/gpu-screen-recorder $out/bin/gpu-screen-recorder \
        --prefix LD_LIBRARY_PATH : ${pkgs.libglvnd}/lib \
        --prefix LD_LIBRARY_PATH : ${nvidia-package}/lib
    '')

    # make the NVIDIA libraries available for sensors-mon
    (pkgs.runCommand "sensors-mon" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${
        inputs.sensors-mon.packages."${stdenv.hostPlatform.system}".default
      }/bin/sensors-mon $out/bin/sensors-mon \
        --prefix LD_LIBRARY_PATH : ${nvidia-package}/lib
    '')
  ];

  fonts = {
    packages = [
      # required to prevent OrcaSlicer segfault
      # https://github.com/OrcaSlicer/OrcaSlicer/issues/10524
      # https://github.com/OrcaSlicer/OrcaSlicer/issues/10029
      # https://github.com/OrcaSlicer/OrcaSlicer/issues/11641
      pkgs.nanum
    ];
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

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
      ssh-port

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
    ports = [ ssh-port ];
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

  services.udev = {
    enable = true;

    # this rule needs to have a custom priority other than 99-local because
    # the uaccess tag needs to be assigned before the 70- tier of priorities
    # https://github.com/systemd/systemd/issues/4288#issuecomment-348166161
    packages = lib.singleton (
      pkgs.writeTextFile {
        name = "aquacomputer-quadro";
        # Aquacomputer Quadro allow access to non-root users
        text = ''
          ACTION!="remove", SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c70", ATTRS{idProduct}=="f00d", MODE="0660", TAG+="uaccess"
          KERNEL=="hidraw*", TAG+="uaccess"
        '';
        destination = "/etc/udev/rules.d/60-aquacomputer-quadro.rules";
      }
    );

    # Disable motherboard bluetooth adapter
    #   ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0616"
    # Disable motherboard USB audio
    #   ATTRS{idVendor}=="0414", ATTRS{idProduct}=="a014"
    # Allow access to Harmonix Rock Band 3 Keytar
    #   SUBSYSTEM=="usb", ATTRS{idVendor}=="1bad", ATTRS{idProduct}=="3330", MODE="0660", GROUP="input"
    extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0e8d", ATTRS{idProduct}=="0616", ATTR{authorized}="0"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="0414", ATTRS{idProduct}=="a014", ATTR{authorized}="0"
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1bad", ATTRS{idProduct}=="3330", MODE="0660", GROUP="input"
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
  };

  # Epson scanner support
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.epkowa ];
  };

  users.users."${config-vars.username}".extraGroups = [
    "lp"
    "scanner"
    "gamemode"
  ];

  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  services.pipewire.extraConfig.pipewire."11-virtual-devices" = {
    "context.objects" = [
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Source/Virtual";
          "node.description" = "Microphone";
          "node.name" = "carla-source";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "CS2 Sink";
          "node.name" = "cs2-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Browser Sink";
          "node.name" = "browser-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Spotify Sink";
          "node.name" = "spotify-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Discord Sink";
          "node.name" = "discord-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Monitoring Sink";
          "node.name" = "monitoring-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Audio Output";
          "node.name" = "carla-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Mic Sink";
          "node.name" = "mic-sink";
        };
      }
      {
        factory = "adapter";
        args = {
          "audio.position" = "FL,FR";
          "factory.name" = "support.null-audio-sink";
          "media.class" = "Audio/Sink";
          "node.description" = "Audio Device";
          "node.name" = "audio-device-sink";
        };
      }
    ];
  };
}
