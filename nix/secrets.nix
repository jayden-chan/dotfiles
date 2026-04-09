let
  jayden = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHPNQGmdC7xUlvrlv1IpDlcV3JYAT4EO7o4EagtmtmI";
  users = [ jayden ];

  grace = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFJ07LC6Oii1E0RYGbDEZcnq1WvB4rw6CF6hU4d87tPu";
  swift = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA0YaPTxlGxyptUvAr5SLj3P7kUMhByvngxqi6mR6PyH";
  systems = [
    grace
    swift
  ];
in
{
  "secrets/mpv-secrets.lua.age".publicKeys = users ++ systems;
  "secrets/redshift.conf.age".publicKeys = users ++ systems;
  "secrets/env.age".publicKeys = users ++ systems;
  "secrets/ssh-config.age".publicKeys = users ++ systems;
}
