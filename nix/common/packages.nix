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
  environment.systemPackages = with pkgs; [
    alsa-utils
    atuin
    awesome
    bash
    bat
    bc
    bitwarden-cli
    bun
    carla
    chromium
    delta
    dig
    eza
    fastfetch
    fd
    ffmpeg-full
    ffmpegthumbnailer
    file
    fontconfig
    gcc
    gedit
    gimp
    git
    gnumake
    go
    imagemagick
    inkscape
    jalv
    jq
    killall
    lazygit
    libnotify
    lsp-plugins
    lua-language-server
    maim
    mpv
    mullvad-browser
    nitrogen
    nixfmt-rfc-style
    nsxiv
    onefetch
    pavucontrol
    picom
    pkg-config
    prettierd
    qrencode
    redshift
    ripgrep
    rofi
    rsync
    shellcheck
    spotify
    starship
    stylua
    taplo
    tmux
    tokei
    usbutils
    vesktop
    wget
    wireguard-tools
    x42-plugins
    xclip
    xcolor
    yaml-language-server
    yt-dlp
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting

    gnome.eog
    gnome.zenity

    nodePackages.typescript-language-server

    python312Packages.grip

    xorg.xev
    xorg.xinput
    xorg.xmodmap
    xorg.xprop
    xorg.xrdb
    xorg.xset

    unstable.devenv
    unstable.neovim
    unstable.nil

    inputs.agenix.packages.${system}.default
    inputs.minichacha.packages."${system}".default
    inputs.spotify-dbus-mon.packages."${system}".default
    inputs.st.packages."${system}".st
    inputs.zen-browser.packages."${system}".specific
  ];
}