{ ... }:

{
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # make battery level reporting work
        Experimental = true;
      };
    };
  };
}
