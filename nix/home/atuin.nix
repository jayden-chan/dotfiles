{ ... }:

{
  programs.atuin = {
    enable = true;

    enableZshIntegration = false;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableNushellIntegration = false;

    flags = [ "--disable-up-arrow" ];

    settings = {
      dialect = "us";
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.jayden.codes";
    };
  };
}
