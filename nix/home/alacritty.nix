{ config-vars, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = false;
        ipc_socket = false;
      };

      window = {
        padding.x = 12;
        padding.y = 5;
        dynamic_padding = true;
        decorations = "None";
        blur = false;
      };

      scrolling.history = 0;

      font = {
        builtin_box_drawing = true;
        size = config-vars.terminal-font-size;
        offset = {
          x = 0;
          y = -1;
        };
        normal = {
          family = "Iosevka Nerd Font";
          style = "Regular";
        };
      };

      colors = {
        primary = {
          background = config-vars.theme.base00;
          foreground = config-vars.theme.base05;
        };

        cursor.cursor = config-vars.theme.cursor;
        selection.background = "#4c4c4d";

        normal = {
          black = config-vars.theme.base02;
          red = config-vars.theme.base0E;
          green = config-vars.theme.base08;
          yellow = config-vars.theme.base0B;
          blue = config-vars.theme.color4;
          magenta = config-vars.theme.base0F;
          cyan = config-vars.theme.color4;
          white = config-vars.theme.base05;
        };

        bright = {
          black = config-vars.theme.base02;
          red = config-vars.theme.base0E;
          green = config-vars.theme.base08;
          yellow = config-vars.theme.base0B;
          blue = config-vars.theme.color4;
          magenta = config-vars.theme.base0F;
          cyan = config-vars.theme.color4;
          white = config-vars.theme.base05;
        };
      };
    };
  };
}
