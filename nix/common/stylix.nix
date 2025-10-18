{
  pkgs,
  config-vars,
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
    package = pkgs.apple-cursor;
    name = "macOS";
    size = 24;
  };

  stylix.fonts = {
    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
    };

    sansSerif = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "FreeSans";
    };

    serif = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "FreeSerif";
    };

    sizes = {
      applications = 10;
    };
  };
}
