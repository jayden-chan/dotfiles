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
    borgbackup
    bun
    carla
    chromium
    dbeaver-bin
    delta
    eza
    fd
    ffmpeg-full
    ffmpegthumbnailer
    file
    firejail
    fontconfig
    gcc
    gedit
    gimp
    git
    gnumake
    go
    gpu-screen-recorder
    imagemagick
    inkscape
    jalv
    jq
    killall
    lazygit
    libnotify
    liquidctl
    lsp-plugins
    lua-language-server
    maim
    mpv
    neofetch
    nitrogen
    nixfmt-rfc-style
    nodejs_20
    nsxiv
    onefetch
    pavucontrol
    picom
    pkg-config
    psensor
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
    vesktop
    wget
    x42-plugins
    xclip
    xcolor
    yt-dlp
    zathura
    zoxide
    zsh-autosuggestions
    zsh-syntax-highlighting

    gnome.eog
    gnome.zenity

    kdePackages.kdeconnect-kde

    python312Packages.grip

    xorg.xev
    xorg.xinput
    xorg.xmodmap
    xorg.xprop
    xorg.xrdb
    xorg.xset

    unstable.neovim
    unstable.devenv
    inputs.zen-browser.packages."${system}".specific
    inputs.minichacha.packages."${system}".default
  ];
}
