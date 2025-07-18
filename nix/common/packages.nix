{
  pkgs,
  unstable,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    age
    alsa-utils
    awesome
    bash
    bat
    bc
    bun
    carla
    chromium
    czkawka-full
    dig
    eog
    eza
    fastfetch
    fd
    ffmpeg-full
    ffmpegthumbnailer
    file
    fontconfig
    fzf
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
    obs-studio
    obsidian
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
    trufflehog
    usbutils
    vesktop
    wget
    wireguard-tools
    x42-plugins
    xclip
    xcolor
    xdotool
    yaml-language-server
    zenity
    zoxide
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
    unstable.feishin
    unstable.firefox-devedition
    unstable.ghostty
    unstable.neovim
    unstable.nil
    unstable.picocrypt
    unstable.picocrypt-cli
    unstable.spotify
    unstable.yt-dlp

    inputs.agenix.packages.${system}.default
    inputs.notifications-dbus-mon.packages."${system}".default
    inputs.spotify-dbus-mon.packages."${system}".default
  ];
}
