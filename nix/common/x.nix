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
        xrdb -merge ${config-vars.dotfiles-dir}/misc/Xresources
        eval $(/run/wrappers/bin/gnome-keyring-daemon --start --components=ssh)
      '';
    };

    # don't bother installing xterm since we don't need it
    excludePackages = with pkgs; [ xterm ];
  };
}
