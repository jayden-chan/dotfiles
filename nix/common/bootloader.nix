{ ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      # only show the last 10 generations in the boot menu
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      useTmpfs = true;

      # default = 50%
      tmpfsSize = "66%";
    };
  };
}
