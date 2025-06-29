{ pkgs, config-vars, ... }:

{
  # use linux-zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    hostName = config-vars.host;
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };

    extraHosts = ''
      ${config-vars.ips.homelab} git.jayden.codes
    '';

    # wg-quick.interfaces = {
    #   wg0 = {
    #     address = [ "10.179.254.3/24" ];
    #     dns = [ config-vars.ips.opnsense ];
    #     privateKey = "...";
    #
    #     peers = [
    #       {
    #         publicKey = "...";
    #         presharedKey = "...";
    #         allowedIPs = [
    #           "10.118.254.0/24"
    #           "10.179.254.0/24"
    #         ];
    #         endpoint = "purple-heron.jayden.codes:35458";
    #         persistentKeepalive = 25;
    #       }
    #     ];
    #   };
    # };
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      cache-size = 2056;
      server = [ config-vars.ips.opnsense ];
    };
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
