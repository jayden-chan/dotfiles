{ config-vars, ... }:

{
  age.identityPaths = [
    "${config-vars.home-dir}/.ssh/nix-secrets-grace"
    "${config-vars.home-dir}/.ssh/nix-secrets-jayden"
  ];

  age.secrets.mpv-secrets = {
    file = ../secrets/mpv-secrets.lua.age;
    path = "${config-vars.home-dir}/.config/mpv/scripts/secrets.lua";
    mode = "0400";
    owner = "jayden";
    group = "users";
  };

  age.secrets.redshift = {
    file = ../secrets/redshift.conf.age;
    path = "${config-vars.home-dir}/.config/redshift.conf";
    mode = "0400";
    owner = "jayden";
    group = "users";
  };

  age.secrets.env = {
    file = ../secrets/env.age;
    path = "${config-vars.home-dir}/.config/ENV";
    mode = "0400";
    owner = "jayden";
    group = "users";
  };
}
