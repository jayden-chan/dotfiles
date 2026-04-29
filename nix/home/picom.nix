{ config-vars, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";

    vSync = config-vars.vsync;

    fade = true;
    fadeDelta = 4;
    fadeSteps = [
      0.03
      0.03
    ];

    fadeExclude = [
      "class_g = 'csgo_linux64'"
      "class_g = 'cs2'"
      "class_g = 'hl2_linux'"
      "class_g = 'steam_app_11020'"
    ];

    shadow = true;
    shadowOpacity = 0.7;

    shadowOffsets = [
      (-12)
      (-12)
    ];

    shadowExclude = [
      "! name~=''"
      "_GTK_FRAME_EXTENTS@"

      # disable shadows for fullscreen windows
      "_NET_WM_STATE@[0] = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[1] = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[2] = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[3] = '_NET_WM_STATE_FULLSCREEN'"
      "_NET_WM_STATE@[4] = '_NET_WM_STATE_FULLSCREEN'"

      "name = 'Notification'"
      "name = 'Docky'"
      "name = 'Kupfer'"
      "name = 'Ulauncher'"
      "class_g = 'Kupfer'"
      "class_g = 'csgo_linux64'"
      "class_g = 'cs2'"
      "class_g = 'steam_app_11020'"
      "class_g = 'hl2_linux'"
      "class_g = 'Synapse'"
      "class_g ?= 'Notify-osd'"
      "class_g ^= 'kdeconnectd'"
      "class_g ^= 'kdeconnect.daemon'"
    ];

    wintypes = {
      tooltip = {
        fade = true;
        shadow = true;
        opacity = 1.0;
        focus = true;
        full-shadow = false;
      };
      dock = {
        shadow = false;
        clip-shadow-above = true;
      };
      dnd = {
        shadow = false;
      };
      utility = {
        shadow = true;
      };
      menu = {
        shadow = false;
      };
      popup_menu = {
        shadow = false;
        opacity = 1.0;
      };
      dropdown_menu = {
        opacity = 1.0;
      };
    };

    settings = {
      transparent-clipping = false;
      use-damage = true;
      detect-transient = true;
      corner-radius = 12;
      shadow-radius = 20;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;

      rounded-corners-exclude = [
        "window_type = 'dock'"
        "class_g = 'csgo_linux64'"
        "class_g = 'cs2'"
        "class_g = 'steam_app_11020'"
        "class_g = 'hl2_linux'"
        "class_g = 'Dunst'"
        "name = 'Awesome drawin'"
        "class_g ^= 'Steam'"
        "class_g ^= 'kdeconnectd'"
        "class_g ^= 'kdeconnect.daemon'"
        "class_g ^= 'steamwebhelper'"
        "class_g ^= 'steam'"
      ];

      transition-rule = [
        "bottom:class_g = 'Rofi'"
      ];

      transition = true;
      transition-offset = 20;
      transition-direction = "smart-x";
      transition-timing-function = "ease-out-quint";
      transition-step = 0.05;
    };
  };
}
