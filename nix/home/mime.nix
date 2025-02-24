{ ... }:

let
  eog = "org.gnome.eog.desktop";
  file-roller = "org.gnome.FileRoller.desktop";
  basic-text-editor = "org.xfce.mousepad.desktop";
  mpv = "mpv.desktop";
  zathura = "org.pwmt.zathura.desktop";
  zen-browser = "zen.desktop";
  protontricks = "protontricks-launch.desktop";
in
{
  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  xdg.mimeApps.defaultApplications = {
    "application/json" = [ basic-text-editor ];
    "application/pdf" = [ zathura ];
    "application/x-extension-htm" = [ zen-browser ];
    "application/x-extension-html" = [ zen-browser ];
    "application/x-extension-shtml" = [ zen-browser ];
    "application/x-extension-xht" = [ zen-browser ];
    "application/x-extension-xhtml" = [ zen-browser ];
    "application/xhtml+xml" = [ zen-browser ];
    "application/zip" = [ file-roller ];
    "audio/flac" = [ mpv ];
    "audio/mpeg" = [ mpv ];
    "audio/x-aiff" = [ mpv ];
    "image/gif" = [ mpv ];
    "image/jpeg" = [ eog ];
    "image/jpg" = [ eog ];
    "image/png" = [ eog ];
    "image/webp" = [ eog ];
    "image/x-portable-pixmap" = [ eog ];
    "text/csv" = [ basic-text-editor ];
    "text/html" = [ zen-browser ];
    "text/plain" = [ basic-text-editor ];
    "text/xml" = [ basic-text-editor ];
    "video/mp4" = [ mpv ];
    "video/x-matroska" = [ mpv ];
    "x-scheme-handler/chrome" = [ zen-browser ];
    "x-scheme-handler/http" = [ zen-browser ];
    "x-scheme-handler/https" = [ zen-browser ];
  };

  xdg.mimeApps.associations.added = {
    "application/x-extension-htm" = [ zen-browser ];
    "application/x-extension-html" = [ zen-browser ];
    "application/x-extension-shtml" = [ zen-browser ];
    "application/x-extension-xht" = [ zen-browser ];
    "application/x-extension-xhtml" = [ zen-browser ];
    "application/x-msdownload" = [ protontricks ];
    "application/xhtml+xml" = [ zen-browser ];
    "text/html" = [ zen-browser ];
    "x-scheme-handler/chrome" = [ zen-browser ];
    "x-scheme-handler/http" = [ zen-browser ];
    "x-scheme-handler/https" = [ zen-browser ];
  };
}
