{
  pkgs,
  config,
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
  imports = [
    ../common/stylix.nix

    ./desktop-files.nix
    ./mime.nix
    ./mpv.nix
    ./xresources.nix
    ./zathura.nix
  ];

  home.username = config-vars.username;
  home.homeDirectory = config-vars.home-dir;

  # let Home Manager install and manage itself
  programs.home-manager.enable = true;

  home.file = {
    ".local/share/zsh/zsh-autosuggestions".source = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    ".local/share/zsh/zsh-syntax-highlighting".source = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
    ".config/wgetrc".text = "hsts-file = ${config-vars.home-dir}/.cache/wget-hsts";
  };

  # home-manager only targets
  stylix.targets.alacritty.enable = true;
  stylix.targets.bat.enable = true;
  stylix.targets.gedit.enable = true;
  stylix.targets.gnome.enable = true;
  stylix.targets.gtk.enable = true;
  stylix.targets.mangohud.enable = true;
  stylix.targets.vesktop.enable = true;
  stylix.targets.zathura.enable = true;

  gtk.cursorTheme = {
    name = "macOS";
    size = 24;
    package = unstable.apple-cursor;
  };

  systemd.user.enable = true;

  services.autorandr.enable = true;
  programs.autorandr = {
    enable = true;

    hooks.postswitch = {
      "set-wallpaper" = ''
        nitrogen --restore
      '';
    };
  };
}
