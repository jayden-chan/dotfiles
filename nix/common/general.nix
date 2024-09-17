{ pkgs, config-vars, ... }:

{
  networking.hostName = config-vars.host;
  networking.networkmanager.enable = true;
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

  services.gnome.gnome-keyring.enable = true;

  programs.direnv = {
    enable = true;
    silent = true;
  };

  programs.zsh.enable = true;
}
