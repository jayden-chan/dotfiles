{ config-vars, ... }:

{
  home.file = {
    ".local/share/applications/mullvad_browser_vpn.desktop".text = ''
      [Desktop Entry]
      Categories=Network;WebBrowser;Security
      Comment=Access the Internet over Mullvad
      Exec=firejail --noprofile --netns=mullvad mullvad-browser --private-window https://mullvad.net/en/check
      GenericName=Web Browser
      Icon=mullvad-browser
      MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https
      Name=Mullvad Browser (VPN)
      Type=Application
      Version=1.4
    '';

    ".local/share/applications/firefox-devedition.desktop".text = ''
      [Desktop Entry]
      Actions=new-private-window;alternate-profile
      Categories=Network;WebBrowser
      Exec=firefox-devedition --name firefox-devedition %U
      GenericName=Web Browser
      Icon=firefox-devedition
      MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https
      Name=Zen
      StartupNotify=true
      StartupWMClass=firefox-devedition
      Terminal=false
      Type=Application
      Version=1.4

      [Desktop Action new-private-window]
      Exec=firefox-devedition --private-window %U
      Name=New Private Window

      [Desktop Action alternate-profile]
      Exec=firefox-devedition --profile ~/.mozilla/firefox/os9o8p15.Alternate %U
      Name=Alternate Profile
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
