{ ... }:

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

    "x-scheme-handler/http" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "x-scheme-handler/https" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "x-scheme-handler/chrome" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "text/html" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-htm" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-html" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-shtml" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/xhtml+xml" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-xhtml" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-xht" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
  };

  xdg.mimeApps.associations.added = {
    "x-scheme-handler/http" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "x-scheme-handler/https" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "x-scheme-handler/chrome" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "text/html" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-htm" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-html" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-shtml" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/xhtml+xml" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-xhtml" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
    "application/x-extension-xht" = [ "userapp-Zen Browser-8OM5T2.desktop" ];
  };
}
