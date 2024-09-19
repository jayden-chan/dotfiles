{ pkgs, config-vars, ... }:

{
  services.xserver = {
    enable = true;
    dpi = 96;

    # key repeat delay and interval rate
    autoRepeatDelay = 270;
    autoRepeatInterval = 35;

    xkb = {
      layout = "us";
      variant = "";
    };

    windowManager.awesome.enable = true;

    displayManager = {
      lightdm = {
        enable = true;
        greeters.gtk.enable = true;
      };

      sessionCommands = ''
        xrdb -merge ${config-vars.home-dir}/.config/Xresources
        rm ${config-vars.home-dir}/.xsession-errors.old

        xmodmap -e "clear lock"
        xmodmap -e "keysym Caps_Lock = Escape"
      '';
    };

    # don't bother installing xterm since we don't need it
    excludePackages = [ pkgs.xterm ];
  };
}
