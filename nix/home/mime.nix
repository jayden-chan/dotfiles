{ ... }:

let
  zen-desktop-file = "userapp-Zen Browser-2GLFU2.desktop";
in
{
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

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

    "x-scheme-handler/http" = [ zen-desktop-file ];
    "x-scheme-handler/https" = [ zen-desktop-file ];
    "x-scheme-handler/chrome" = [ zen-desktop-file ];
    "text/html" = [ zen-desktop-file ];
    "application/x-extension-htm" = [ zen-desktop-file ];
    "application/x-extension-html" = [ zen-desktop-file ];
    "application/x-extension-shtml" = [ zen-desktop-file ];
    "application/xhtml+xml" = [ zen-desktop-file ];
    "application/x-extension-xhtml" = [ zen-desktop-file ];
    "application/x-extension-xht" = [ zen-desktop-file ];
  };

  xdg.mimeApps.associations.added = {
    "x-scheme-handler/http" = [ zen-desktop-file ];
    "x-scheme-handler/https" = [ zen-desktop-file ];
    "x-scheme-handler/chrome" = [ zen-desktop-file ];
    "text/html" = [ zen-desktop-file ];
    "application/x-extension-htm" = [ zen-desktop-file ];
    "application/x-extension-html" = [ zen-desktop-file ];
    "application/x-extension-shtml" = [ zen-desktop-file ];
    "application/xhtml+xml" = [ zen-desktop-file ];
    "application/x-extension-xhtml" = [ zen-desktop-file ];
    "application/x-extension-xht" = [ zen-desktop-file ];
  };
}
