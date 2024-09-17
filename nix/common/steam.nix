{ pkgs, ... }:

{
  programs.gamemode.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
    localNetworkGameTransfers.openFirewall = false;
  };

  environment.systemPackages = with pkgs; [ mangohud ];
}
