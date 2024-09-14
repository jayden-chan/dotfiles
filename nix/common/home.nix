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
  home.username = config-vars.username;
  home.homeDirectory = config-vars.home-dir;

  # let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.file = {
    ".local/share/zsh/zsh-autosuggestions".source = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    ".local/share/zsh/zsh-syntax-highlighting".source = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
  };

  home.pointerCursor = {
    name = "macOS";
    package = unstable.apple-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  gtk.cursorTheme = {
    name = "macOS";
    size = 24;
    package = unstable.apple-cursor;
  };

  xdg.mimeApps.defaultApplications = {
    "application/json" = [ "org.gnome.gedit.desktop" ];
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    "application/zip" = [ "org.gnome.FileRoller.desktop" ];
    "audio/flac" = [ "mpv.desktop" ];
    "audio/mpeg" = [ "mpv.desktop" ];
    "audio/x-aiff" = [ "mpv.desktop" ];
    "image/gif" = [ "mpv.desktop" ];
    "image/jpeg" = [ "org.gnome.eog.desktop" ];
    "image/jpg" = [ "org.gnome.eog.desktop" ];
    "image/png" = [ "org.gnome.eog.desktop" ];
    "image/webp" = [ "org.gnome.eog.desktop" ];
    "image/x-portable-pixmap" = [ "org.gnome.eog.desktop" ];
    "text/csv" = [ "org.gnome.gedit.desktop" ];
    "text/plain" = [ "org.gnome.gedit.desktop" ];
    "text/xml" = [ "org.gnome.gedit.desktop" ];
    "video/mp4" = [ "mpv.desktop" ];
    "video/x-matroska" = [ "mpv.desktop" ];
  };

  services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;

    hooks.postswitch = {
      "set-wallpaper" = ''
        nitrogen --restore
      '';
    };
  };
}
