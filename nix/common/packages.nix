{
  pkgs,
  unstable,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    age
    age-plugin-yubikey
    alsa-utils
    awesome
    bash
    bat
    bc
    brave
    bruno
    bun
    carla
    czkawka-full
    dig
    eza
    fastfetch
    fd
    feishin
    ffmpeg-full
    ffmpegthumbnailer
    file
    file-roller
    fontconfig
    fzf
    gimp
    gnumake
    go
    gparted
    htop
    imagemagick
    jalv
    jq
    killall
    libnotify
    lsp-plugins
    maim
    mediainfo
    mullvad-browser
    nil
    nitrogen
    nixfmt-rfc-style
    nsxiv
    passage
    pavucontrol
    picom
    prettierd
    qview
    redshift
    ripgrep
    rofi
    rsync
    stylua
    taplo
    tokei
    trash-cli
    typst
    usbutils
    vesktop
    wireguard-tools
    x42-plugins
    xclip
    xcolor
    xdotool
    yq-go
    yubikey-manager
    zbar
    zoxide
    zsh-syntax-highlighting

    bash-language-server
    lua-language-server
    typescript-language-server
    yaml-language-server

    # needed for nvim tree-sitter
    gcc
    tree-sitter

    python312Packages.grip

    xfce.mousepad

    xorg.xev
    xorg.xinput
    xorg.xmodmap
    xorg.xprop
    xorg.xrdb
    xorg.xset

    unstable.firefox-devedition
    unstable.ghostty
    unstable.spotify
    unstable.yt-dlp
    unstable.neovim

    inputs.agenix.packages.${stdenv.hostPlatform.system}.default
    inputs.notifications-dbus-mon.packages."${stdenv.hostPlatform.system}".default
    inputs.spotify-dbus-mon.packages."${stdenv.hostPlatform.system}".default
  ];
}
