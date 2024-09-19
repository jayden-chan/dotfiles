{ pkgs, config-vars, ... }:

{
  networking = {
    hostName = config-vars.host;
    networkmanager.enable = true;

    extraHosts = ''
      10.118.254.125 git.jayden.codes
    '';
  };

  time.timeZone = config-vars.timezone;
  i18n.defaultLocale = config-vars.locale;

  users.users."${config-vars.username}" = {
    description = config-vars.name;
    home = config-vars.home-dir;
    createHome = true;
    group = "users";
    uid = 1000;
    isNormalUser = true;
    shell = pkgs.zsh;

    extraGroups = [
      "audio"
      "video"
      "input"
      "networkmanager"
      "wheel"
    ];
  };

  programs.direnv = {
    enable = true;
    silent = true;
  };

  programs.zsh.enable = true;
}
