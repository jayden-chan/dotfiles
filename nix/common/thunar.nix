{ pkgs, config-vars, ... }:

let
  package = pkgs.xfce.thunar.override {
    thunarPlugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };
in
{
  # xfconf is required to persist Thunar settings
  # since we're not running on XFCE
  programs.xfconf.enable = true;

  # gvfs is for Thunar stuff like Trash folders etc
  services.gvfs.enable = true;

  # thumbnail generation service for Thunar
  services.tumbler.enable = true;

  environment.systemPackages = [ package ];
  services.dbus.packages = [ package ];
  systemd.packages = [ package ];
}
