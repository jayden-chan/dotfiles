{ lib, pkgs, ... }:

{
  # fix audio plugin discovery paths since NixOS isn't FHS-compliant
  environment.variables =
    let
      makePluginPath =
        format:
        (lib.strings.makeSearchPath format [
          "$HOME/.nix-profile/lib"
          "/run/current-system/sw/lib"
          "/etc/profiles/per-user/$USER/lib"
        ])
        + ":$HOME/.${format}";
    in
    {
      DSSI_PATH = makePluginPath "dssi";
      LADSPA_PATH = makePluginPath "ladspa";
      LV2_PATH = makePluginPath "lv2";
      LXVST_PATH = makePluginPath "lxvst";
      VST_PATH = makePluginPath "vst";
      VST3_PATH = makePluginPath "vst3";
    };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
      extraLv2Packages = [
        pkgs.lsp-plugins
        pkgs.x42-plugins
      ];
    };

    extraLv2Packages = [
      pkgs.lsp-plugins
      pkgs.x42-plugins
    ];
  };
}
