{ lib, ... }:

let
  settings = {
    # need to override the stylix font size here
    font_size = lib.mkForce 24;
    font_size_text = lib.mkForce 24;
    font_scale = lib.mkForce 0.6;

    position = "bottom-left";
    horizontal_stretch = 0;
    hud_no_margin = 1;
    hud_compact = 1;
    horizontal = 1;
    cpu_mhz = 1;
    gpu_core_clock = 1;
    ram = 1;
    swap = 1;
    frametime = 0;
    frame_timing = 0;
  };
in

{
  programs.mangohud = {
    enable = true;
    inherit settings;
    settingsPerApplication = {
      wine-hitman3 = lib.recursiveUpdate settings {
        fps_limit = 240;
      };
    };
  };
}
