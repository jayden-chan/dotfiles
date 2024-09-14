{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Iosevka"
          "JetBrainsMono"
        ];
      })
    ];

    fontconfig = {
      hinting.style = "slight";
      hinting.enable = true;
      hinting.autohint = false;

      subpixel.rgba = "rgb";

      defaultFonts.serif = [ "FreeSerif" ];
      defaultFonts.sansSerif = [ "FreeSans" ];
      defaultFonts.monospace = [ "JetBrainsMono Nerd Font Mono" ];
    };
  };
}
