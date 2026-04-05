{ pkgs, ... }:

{
  fonts = {
    packages = [
      pkgs.nerd-fonts.iosevka
      pkgs.nerd-fonts.jetbrains-mono
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
