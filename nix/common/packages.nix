{
  pkgs,
  unstable,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    alsa-utils
    awesome
    bash
    bat
    bc
    bitwarden-cli
    bun
    carla
    chromium
    dig
    eog
    eza
    fastfetch
    fd
    feishin
    ffmpeg-full
    ffmpegthumbnailer
    file
    fontconfig
    gcc
    gimp
    gnumake
    go
    imagemagick
    jalv
    jq
    killall
    libnotify
    lsp-plugins
    lua-language-server
    maim
    mediainfo
    mullvad-browser
    nitrogen
    nixfmt-rfc-style
    nsxiv
    onefetch
    pavucontrol
    picom
    pkg-config
    prettierd
    redshift
    ripgrep
    rofi
    rsync
    shellcheck
    stylua
    taplo
    tokei
    trash-cli
    usbutils
    vesktop
    wget
    wireguard-tools
    x42-plugins
    xclip
    xcolor
    yaml-language-server
    zenity
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting

    nodePackages.typescript-language-server

    python312Packages.grip

    xfce.mousepad

    xorg.xev
    xorg.xinput
    xorg.xmodmap
    xorg.xprop
    xorg.xrdb
    xorg.xset

    unstable.bruno
    unstable.devenv
    unstable.ghostty
    unstable.neovim
    unstable.nil
    unstable.picocrypt
    unstable.spotify
    unstable.yt-dlp

    inputs.agenix.packages.${system}.default
    inputs.notifications-dbus-mon.packages."${system}".default
    inputs.spotify-dbus-mon.packages."${system}".default
    inputs.zen-browser.packages."${system}".default
  ];
}
