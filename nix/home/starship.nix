{ ... }:

{
  programs.starship = {
    enable = true;

    enableZshIntegration = false;
    enableTransience = false;
    enableNushellIntegration = false;
    enableIonIntegration = false;
    enableFishIntegration = false;
    enableBashIntegration = false;

    settings = {
      time = {
        disabled = true;
      };

      character = {
        error_symbol = "[✗](bold red)";
        success_symbol = "[:](bold green)";
      };

      package = {
        disabled = true;
      };

      gcloud = {
        disabled = true;
      };

      git_status = {
        disabled = false;
      };

      git_commit = {
        disabled = false;
      };

      nix_shell = {
        impure_msg = "[impure](bold red)";
        pure_msg = "[pure](bold green)";
        unknown_msg = "[unknown](bold yellow)";
        format = "via [❄️$state( \($name\))](bold blue) ";
      };

      custom = {
        gwip = {
          command = "git log -n 1 2>/dev/null | rg --quiet --count --regexp \"--wip--\" && echo '[WORK IN PROGRESS]'";
          when = "git rev-parse --is-inside-work-tree 2>/dev/null";
          format = "[$output](bold red)";
        };
      };
    };
  };
}
