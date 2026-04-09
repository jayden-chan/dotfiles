{ pkgs, config-vars, ... }:

{
  # use linux-zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  programs.firejail.enable = true;

  networking = {
    hostName = config-vars.host;
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };

    extraHosts = ''
      ${config-vars.ips.homelab} git.jayden.codes
    '';
  };

  fileSystems."homelab" = {
    device = "${config-vars.ips.homelab}:/";
    mountPoint = "/mnt/homelab";
    fsType = "nfs";
    options = [
      "nfsvers=4.2"
      "noatime"
      "_netdev"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "x-systemd.mount-timeout=10"
    ];
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
  services.pcscd.enable = true;
}
