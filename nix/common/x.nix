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
      lightdm.enable = true;
      lightdm.greeters.gtk.enable = true;
      sessionCommands = ''
        xrdb -merge ${config-vars.home-dir}/.config/dotfiles/misc/Xresources
      '';
    };

    # don't bother installing xterm since we don't need it
    excludePackages = with pkgs; [ xterm ];
  };
}
