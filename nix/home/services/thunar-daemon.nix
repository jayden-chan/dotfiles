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
  systemd.user.services.thunar-daemon = {
    Unit = {
      Description = "Thunar background daemon";
      After = "graphical-session-pre.target";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      Environment = "XDG_DATA_HOME=${config-vars.home-dir}/.local/share";
      ExecStart = "${package}/bin/Thunar --daemon";
    };
  };
}
