{ config-vars, ... }:

{
  xresources = {
    path = "${config-vars.home-dir}/.config/Xresources";
    extraConfig = ''
      #define _color0 ${config-vars.theme.base00}
      #define _color1 ${config-vars.theme.base0E}
      #define _color2 ${config-vars.theme.base08}
      #define _color3 ${config-vars.theme.base0B}
      #define _color4 ${config-vars.theme.color4}
      #define _color5 ${config-vars.theme.base0F}
      #define _color6 ${config-vars.theme.color4}
      #define _color7 ${config-vars.theme.base07}
      #define _color8 ${config-vars.theme.base02}
      #define _color9 ${config-vars.theme.base0E}
      #define _color10 ${config-vars.theme.base08}
      #define _color11 ${config-vars.theme.base0B}
      #define _color12 ${config-vars.theme.color4}
      #define _color13 ${config-vars.theme.base0F}
      #define _color14 ${config-vars.theme.color4}
      #define _color15 ${config-vars.theme.base05}
      #define _color16 ${config-vars.theme.base0C}

      #define _cursorColor ${config-vars.theme.cursor}
      #define _background ${config-vars.theme.base00}
      #define _foreground ${config-vars.theme.base05}
    '';
  };
}
