{ pkgs, config-vars, ... }:

{
  home.file = {
    ".local/share/applications/chromium_mullvad.desktop".text = ''
      [Desktop Entry]
      Exec=${pkgs.firejail}/bin/firejail --noprofile --netns=mullvad chromium --incognito https://mullvad.net/en/check
      Type=Application
      Version=1.0
      Name=Chromium (Mullvad)
      Comment=Access the Internet over Mullvad
      Icon=chromium
      Terminal=false
      Categories=Network;WebBrowser;
      MimeType=application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;
    '';

    ".local/share/applications/wallpaper.desktop".text = ''
      [Desktop Entry]
      Exec=${config-vars.dotfiles-dir}/scripts/wallpaper/wallpaper.sh "${config-vars.home-dir}/Pictures/Wallpapers/Single Screen"
      Type=Application
      Version=1.0
      Name=Wallpaper
      Comment=Set the wallpaper for the desktop and login manager
      Icon=${config-vars.dotfiles-dir}/scripts/wallpaper/wallpaper-ico.png
      Terminal=false
    '';
  };
}
