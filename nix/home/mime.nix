{ ... }:

let
  basic-text-editor = "org.xfce.mousepad.desktop";
  browser = "firefox-devedition.desktop";
  file-roller = "org.gnome.FileRoller.desktop";
  mpv = "mpv.desktop";
  nsxiv = "nsxiv.desktop";
  protontricks = "protontricks-launch.desktop";
  qview = "com.interversehq.qView.desktop";
  thunar = "thunar.desktop";
  zathura = "org.pwmt.zathura.desktop";
in
{
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;
  xdg.configFile."mimeapps.list".force = true;

  xdg.mimeApps.defaultApplications = {
    "application/json" = [ basic-text-editor ];
    "application/pdf" = [ zathura ];
    "application/x-extension-htm" = [ browser ];
    "application/x-extension-html" = [ browser ];
    "application/x-extension-shtml" = [ browser ];
    "application/x-extension-xht" = [ browser ];
    "application/x-extension-xhtml" = [ browser ];
    "application/xhtml+xml" = [ browser ];
    "application/zip" = [ file-roller ];
    "audio/flac" = [ mpv ];
    "audio/mpeg" = [ mpv ];
    "audio/x-aiff" = [ mpv ];
    "image/gif" = [ mpv ];
    "image/jpeg" = [ qview ];
    "image/jpg" = [ qview ];
    "image/png" = [ qview ];
    "image/svg+xml" = [ nsxiv ];
    "image/webp" = [ qview ];
    "image/x-portable-pixmap" = [ qview ];
    "inode/directory" = [ thunar ];
    "text/csv" = [ basic-text-editor ];
    "text/html" = [ browser ];
    "text/plain" = [ basic-text-editor ];
    "text/xml" = [ basic-text-editor ];
    "video/mp4" = [ mpv ];
    "video/x-matroska" = [ mpv ];
    "x-scheme-handler/chrome" = [ browser ];
    "x-scheme-handler/http" = [ browser ];
    "x-scheme-handler/https" = [ browser ];
  };

  xdg.mimeApps.associations.added = {
    "application/x-extension-htm" = [ browser ];
    "application/x-extension-html" = [ browser ];
    "application/x-extension-shtml" = [ browser ];
    "application/x-extension-xht" = [ browser ];
    "application/x-extension-xhtml" = [ browser ];
    "application/x-msdownload" = [ protontricks ];
    "application/xhtml+xml" = [ browser ];
    "text/html" = [ browser ];
    "x-scheme-handler/chrome" = [ browser ];
    "x-scheme-handler/http" = [ browser ];
    "x-scheme-handler/https" = [ browser ];
  };
}
