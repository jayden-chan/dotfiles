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

    properties = {
      "st.font" = "Iosevka Nerd Font Mono:pixelsize=16:antialias=true:autohint=false:fonthashint=true";
      "st.cwscale" = "1.0";
      "st.chscale" = "0.90";
      "st.borderpx" = "11";
      "st.color0" = "_color0";
      "st.color1" = "_color1";
      "st.color2" = "_color2";
      "st.color3" = "_color3";
      "st.color4" = "_color4";
      "st.color5" = "_color5";
      "st.color6" = "_color6";
      "st.color7" = "_color7";
      "st.color8" = "_color8";
      "st.color9" = "_color9";
      "st.color10" = "_color10";
      "st.color11" = "_color11";
      "st.color12" = "_color12";
      "st.color13" = "_color13";
      "st.color14" = "_color14";
      "st.color15" = "_color15";
      "st.cursorColor" = "_cursorColor";
      "st.background" = "_background";
      "st.foreground" = "_foreground";
    };
  };
}
