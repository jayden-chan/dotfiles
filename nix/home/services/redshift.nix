{ pkgs, config-vars, ... }:

{
  systemd.user.services.redshift = {
    Unit = {
      Description = "set color temperature of display according to time of day";
      After = "graphical-session-pre.target";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.redshift}/bin/redshift";
    };
  };
}
