{ lib, pkgs, ... }:

{
  # fix audio plugin discovery paths since NixOS isn't FHS-compliant
  environment.variables =
    let
      makePluginPath =
        format:
        (lib.strings.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
      extraLv2Packages = [
        pkgs.lsp-plugins
        pkgs.x42-plugins
      ];
    };

    extraLv2Packages = [
      pkgs.lsp-plugins
      pkgs.x42-plugins
    ];

    extraConfig = {
      pipewire-pulse = {
        "10-resample-quality" = {
          "stream.properties" = {
            "resample.quality" = 10;
          };
        };
      };

      jack = {
        "10-clock-rate" = {
          "jack.properties" = {
            "node.latency" = "256/48000";
            "node.rate" = "1/48000";
            "node.lock-quantum" = true;
          };
        };
      };

      pipewire = {
        "10-clock-rate" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.allowed-rates" = [
              44100
              48000
            ];

            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 16;
            "default.clock.max-quantum" = 8192;
          };
        };

        "11-virtual-devices" = {
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
      };
    };
  };
}
