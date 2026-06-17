{ config-vars, ... }:

{
  age.identityPaths = [
    "${config-vars.home-dir}/.ssh/nix-secrets-grace"
    "${config-vars.home-dir}/.ssh/nix-secrets-swift"
    "${config-vars.home-dir}/.ssh/nix-secrets-jayden"
  ];

  age.secrets.mpv-secrets = {
    file = ../secrets/mpv-secrets.lua.age;
    path = "${config-vars.home-dir}/.config/mpv/scripts/secrets.lua";
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets."redshift.conf" = {
    file = ../secrets/redshift.conf.age;
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets.env = {
    file = ../secrets/env.age;
    path = "${config-vars.home-dir}/.config/ENV";
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets.ssh-config = {
    file = ../secrets/ssh-config.age;
    path = "${config-vars.home-dir}/.ssh/config";
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets.smtp-pass = {
    file = ../secrets/smtp-pass.age;
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets."gps-coords.json" = {
    file = ../secrets/gps-coords.json.age;
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets."cookies-backup" = {
    file = ../secrets/cookies-backup.age;
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };

  age.secrets."llama-api-key" = {
    file = ../secrets/llama-api-key.age;
    mode = "0400";
    owner = config-vars.username;
    group = "users";
  };
}
