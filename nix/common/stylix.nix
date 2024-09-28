{
  pkgs,
  config-vars,
  unstable,
  ...
}:

{
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.polarity = "dark";

  # I'm not even using the stylix wallpaper functionality
  # but it barfs if you don't set this option
  stylix.image = ./wall;

  stylix.base16Scheme = config-vars.theme;

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
