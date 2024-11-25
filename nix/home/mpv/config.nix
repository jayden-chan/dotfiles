{ ... }:

{
  imports = [
    ./script-all-audio.nix
    ./script-append-url.nix
    ./script-cut-video.nix
  ];

  programs.mpv = {
    enable = true;
    bindings = {
      "MBTN_LEFT" = "cycle pause";
      "WHEEL_RIGHT" = "seek 10";
      "WHEEL_LEFT" = "seek -10";
      "WHEEL_DOWN" = "add volume -2";
      "WHEEL_UP" = "add volume 2";
      "UP" = "add volume  2";
      "DOWN" = "add volume -2";
      "V" = "cycle sub";
      "L" = "cycle-values loop-file inf no";
    };

    config = {
      osd-scale-by-window = false;
      osd-bar = false;
      osd-scale = 0.7;
      sub-scale = 0.5;
      loop = true;
      mute = true;
      volume = 50;
      autofit-larger = 1200;
    };

    scriptOpts = {
      osc = {
        scalefullscreen = 0.8;
      };
    };
  };
}
