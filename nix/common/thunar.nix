{ pkgs, ... }:

{
  # xfconf is required to persist Thunar settings
  # since we're not running on XFCE
  programs.xfconf.enable = true;

  # gvfs is for Thunar stuff like Trash folders etc
  services.gvfs.enable = true;

  # thumbnail generation service for Thunar
  services.tumbler.enable = true;

  # required for Thunar archive plugin
  programs.file-roller.enable = true;

  # Thunar
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
}
