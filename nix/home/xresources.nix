{ config-vars, ... }:

{
  xresources = {
    path = "${config-vars.home-dir}/.config/Xresources";
    extraConfig = ''
      #define _color0 #202022
      #define _color1 #e67e80
      #define _color2 #a7c080
      #define _color3 #dbbc7f
      #define _color4 #95d1c9
      #define _color5 #d699b6
      #define _color6 #95d1c9
      #define _color7 #e7dabe
      #define _color8 #3a3a3a
      #define _color9 #e67e80
      #define _color10 #a7c080
      #define _color11 #dbbc7f
      #define _color12 #95d1c9
      #define _color13 #d699b6
      #define _color14 #95d1c9
      #define _color15 #d3c6aa
      #define _color16 #d65d0e

      #define _cursorColor #b5b1a4
      #define _background #202022
      #define _foreground #d3c7bb
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
