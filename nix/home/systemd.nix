{
  pkgs,
  inputs,
  ...
}:
let
  thunar-package = pkgs.thunar.override {
    thunarPlugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  notification-dbus-mon-package =
    inputs.notifications-dbus-mon.packages."${pkgs.stdenv.hostPlatform.system}".default;
in
{
  systemd.user.services."notifications-dbus-mon" = {
    Unit = {
      Description = "Notifications dbus mon";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.lib.getExe' notification-dbus-mon-package "notifications-dbus-mon"}";
    };
  };

  systemd.user.services."thunar" = {
    Unit = {
      Description = "Thunar daemon";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.lib.getExe' thunar-package "thunar"} --daemon";
    };
  };

  systemd.user.services."redshift" = {
    Unit = {
      Description = "Redshift colour temperature adjuster";
      After = "graphical-session.target";
      PartOf = "graphical-session.target";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.lib.getExe' pkgs.redshift "redshift"} -c /run/agenix/redshift.conf";
    };
  };
}
