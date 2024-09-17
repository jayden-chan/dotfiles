{ pkgs, config-vars, ... }:

{
  systemd.user.services.picom = {
    Unit = {
      Description = "picom compositor";
      After = "graphical-session-pre.target";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.picom}/bin/picom --config ${config-vars.dotfiles-dir}/misc/picom.conf";
    };
  };
}
