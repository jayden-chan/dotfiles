{ ... }:

{
  home.file = {
    ".config/pnpm/config.yaml".text = # yaml
      ''
        # 1 week cooldown
        minimumReleaseAge: 10080
        minimumReleaseAgeExclude:
          - '@saasquatch/*'

        npmrcAuthFile: ''${NPM_CONFIG_USERCONFIG}

        updateNotifier: false
      '';
  };
}
