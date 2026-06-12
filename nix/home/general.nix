{
  pkgs,
  unstable,
  config-vars,
  ...
}:

{
  imports = [
    ../common/stylix.nix

    ./mpv/config.nix

    ./alacritty.nix
    ./desktop-files.nix
    ./email.nix
    ./git.nix
    ./lazygit.nix
    ./mime.nix
    ./picom.nix
    ./pnpm.nix
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
  };

  # home-manager only targets
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
      package = pkgs.apple-cursor;
    };

    iconTheme = {
      package = pkgs.numix-icon-theme;
      name = "Numix";
    };
  };

  services.kdeconnect.enable = true;

  systemd.user.enable = true;

  programs.autorandr.enable = true;
  services.autorandr = {
    enable = true;
    matchEdid = true;
  };

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

  systemd.user.services."cookies-backup" = {
    Unit = {
      Description = "Firefox cookies backup";
    };

    Service = {
      ExecStart = pkgs.writeShellScript "cookies-backup" ''
        set -euo pipefail
        profile_path="${config-vars.home-dir}/$(${pkgs.lib.getExe' pkgs.gnused "sed"} -n '1p' /run/agenix/cookies-backup)"
        cookies_tmp_path="$(${pkgs.lib.getExe' pkgs.coreutils "mktemp"} --tmpdir=/dev/shm cookies-backup-XXXXX.txt)"
        ${pkgs.lib.getExe' pkgs.coreutils "rm"} "$cookies_tmp_path"
        set +e
        ${pkgs.lib.getExe' unstable.yt-dlp "yt-dlp"} --cookies-from-browser "firefox:$profile_path" --cookies "$cookies_tmp_path"
        set -e
        ${pkgs.lib.getExe' pkgs.coreutils "cp"} "$cookies_tmp_path" "$(${pkgs.lib.getExe' pkgs.gnused "sed"} -n '2p' /run/agenix/cookies-backup)"
        ${pkgs.lib.getExe' pkgs.coreutils "rm"} -f "$cookies_tmp_path"
      '';
    };
  };

  systemd.user.timers."cookies-backup" = {
    Unit = {
      Description = "Firefox cookies backup";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };

    Timer = {
      OnCalendar = "daily";
      Unit = "cookies-backup.service";
    };
  };
}
