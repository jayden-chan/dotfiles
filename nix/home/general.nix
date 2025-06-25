{
  pkgs,
  config-vars,
  unstable,
  ...
}:

{
  imports = [
    ../common/stylix.nix

    ./mpv/config.nix

    ./desktop-files.nix
    ./ghostty.nix
    ./git.nix
    ./lazygit.nix
    ./mangohud.nix
    ./mime.nix
    ./starship.nix
    ./thunar-uca.nix
    ./tmux.nix
    ./xresources.nix
    ./zathura.nix
  ];

  home.username = config-vars.username;
  home.homeDirectory = config-vars.home-dir;

  # let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.file = {
    ".local/share/zsh/zsh-syntax-highlighting".source =
      "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
    ".config/wgetrc".text = "hsts-file = ${config-vars.home-dir}/.cache/wget-hsts";
  };

  # home-manager only targets
  stylix.targets.alacritty.enable = true;
  stylix.targets.bat.enable = true;
  stylix.targets.gnome.enable = true;
  stylix.targets.gtk.enable = true;
  stylix.targets.mangohud.enable = true;
  stylix.targets.xfce.enable = true;
  stylix.targets.zathura.enable = true;

  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS";
      size = 24;
      package = unstable.apple-cursor;
    };

    iconTheme = {
      package = pkgs.numix-icon-theme;
      name = "Numix";
    };
  };

  services.kdeconnect.enable = true;

  systemd.user.enable = true;

  services.autorandr.enable = true;
  programs.autorandr.enable = true;

  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
    enableSshSupport = true;

    pinentry.package = pkgs.pinentry-rofi;

    # 24 hours
    maxCacheTtl = 86400;
    maxCacheTtlSsh = 86400;
    defaultCacheTtl = 86400;
    defaultCacheTtlSsh = 86400;

    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;
    enableScDaemon = false;
  };
}
