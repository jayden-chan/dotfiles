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
    borgbackup
    bun
    carla
    dbeaver-bin
    delta
    eza
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
    gpu-screen-recorder
    imagemagick
    jalv
    jq
    killall
    lazygit
    libnotify
    liquidctl
    lsp-plugins
    maim
    mpv
    neofetch
    nitrogen
    nixfmt-rfc-style
    nodejs_20
    nsxiv
    onefetch
    pavucontrol
    pkg-config
    psensor
    redshift
    ripgrep
    rofi
    rsync
    spotify
    starship
    taplo
    tmux
    tokei
    usbutils
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
