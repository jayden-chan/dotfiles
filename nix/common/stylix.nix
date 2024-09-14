{
  pkgs,
  config-vars,
  inputs,
  ...
}:

let
  unstable = import inputs.nixpkgs-unstable {
    system = config-vars.system;
    config.allowUnfree = true;
  };
in
{
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.polarity = "dark";

  # I'm not even using the stylix wallpaper functionality
  # but it barfs if you don't set this option
  stylix.image = ./wall;

  stylix.base16Scheme = {
    base00 = "#202022";
    base01 = "#323c41";
    base02 = "#3c444a";
    base03 = "#424a50";
    base04 = "#4a5258";
    base05 = "#d3c7bb";
    base06 = "#ddd0b4";
    base07 = "#e7dabe";
    base08 = "#7fbbb3";
    base09 = "#d699b6";
    base0A = "#83c092";
    base0B = "#dbbc7f";
    base0C = "#e69875";
    base0D = "#a7c080";
    base0E = "#e67e80";
    base0F = "#d699b6";
  };

  stylix.cursor = {
    package = unstable.apple-cursor;
    name = "macOS";
    size = 24;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "FreeSans";
    };
    serif = {
      package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      name = "FreeSerif";
    };

    sizes = {
      applications = 10;
    };
  };
}
