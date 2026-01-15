{ pkgs, ... }:

{
  fonts = {
    packages = [
      pkgs.nerd-fonts.iosevka
      pkgs.nerd-fonts.jetbrains-mono

      # required to prevent OrcaSlicer segfault
      # https://github.com/OrcaSlicer/OrcaSlicer/issues/10524
      # https://github.com/OrcaSlicer/OrcaSlicer/issues/10029
      # https://github.com/OrcaSlicer/OrcaSlicer/issues/11641
      pkgs.nanum
      pkgs.nanum-gothic-coding
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
