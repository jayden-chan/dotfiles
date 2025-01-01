{ config-vars, ... }:
{
  home.file.".config/ghostty/config".text =
    # ini
    ''
      auto-update = off
      clipboard-read = allow
      confirm-close-surface = false
      font-family = "Iosevka Nerd Font"
      font-size = 12
      gtk-tabs-location = hidden
      scrollback-limit = 0
      shell-integration = none
      window-decoration = false
      window-padding-balance = true
      window-padding-color = background
      window-padding-x = 8
      window-padding-y = 5

      # clear default keybinds
      keybind = alt+one=unbind
      keybind = alt+two=unbind
      keybind = alt+three=unbind
      keybind = alt+four=unbind
      keybind = alt+five=unbind
      keybind = alt+six=unbind
      keybind = alt+seven=unbind
      keybind = alt+eight=unbind
      keybind = alt+nine=unbind
      keybind = super+ctrl+shift+up=unbind
      keybind = super+ctrl+shift+equal=unbind
      keybind = super+ctrl+shift+left=unbind
      keybind = super+ctrl+shift+down=unbind
      keybind = super+ctrl+shift+right=unbind
      keybind = ctrl+alt+shift+j=unbind
      keybind = super+ctrl+right_bracket=unbind
      keybind = super+ctrl+left_bracket=unbind
      keybind = ctrl+alt+up=unbind
      keybind = ctrl+alt+left=unbind
      keybind = ctrl+alt+down=unbind
      keybind = ctrl+alt+right=unbind
      keybind = ctrl+shift+a=unbind
      keybind = ctrl+shift+o=unbind
      keybind = ctrl+shift+q=unbind
      keybind = ctrl+shift+n=unbind
      keybind = ctrl+shift+page_down=unbind
      keybind = ctrl+shift+left=unbind
      keybind = ctrl+shift+w=unbind
      keybind = ctrl+shift+j=unbind
      keybind = ctrl+shift+right=unbind
      keybind = ctrl+shift+page_up=unbind
      keybind = ctrl+shift+t=unbind
      keybind = ctrl+shift+tab=unbind
      keybind = ctrl+shift+e=unbind
      keybind = ctrl+shift+enter=unbind
      keybind = alt+f4=unbind
      keybind = ctrl+page_down=unbind
      keybind = ctrl+page_up=unbind
      keybind = ctrl+tab=unbind
      keybind = ctrl+comma=unbind
      keybind = ctrl+enter=unbind
      keybind = shift+insert=unbind
      keybind = shift+page_up=unbind
      keybind = shift+end=unbind
      keybind = shift+page_down=unbind
      keybind = shift+home=unbind

      palette = 0=${config-vars.theme.base00}
      palette = 1=${config-vars.theme.base0E}
      palette = 2=${config-vars.theme.base08}
      palette = 3=${config-vars.theme.base0B}
      palette = 4=${config-vars.theme.color4}
      palette = 5=${config-vars.theme.base0F}
      palette = 6=${config-vars.theme.color4}
      palette = 7=${config-vars.theme.base07}
      palette = 8=${config-vars.theme.base02}
      palette = 9=${config-vars.theme.base0E}
      palette = 10=${config-vars.theme.base08}
      palette = 11=${config-vars.theme.base0B}
      palette = 12=${config-vars.theme.color4}
      palette = 13=${config-vars.theme.base0F}
      palette = 14=${config-vars.theme.color4}
      palette = 15=${config-vars.theme.base05}

      background = ${config-vars.theme.base00}
      foreground = ${config-vars.theme.base05}
      cursor-color = ${config-vars.theme.cursor}
      selection-background = 4c4c4d
      selection-foreground = ${config-vars.theme.base05}
    '';
}
