{ pkgs, ... }:

{
  # setup the sudoers lecture
  security.sudo.extraConfig = ''
    Defaults lecture = always
    Defaults lecture_file = ${
      pkgs.writeTextFile {
        name = "sudoers-lecture";
        text = ''

          [1m     [32m"Bee" careful    [34m__
                 [32mwith sudo!    [34m// \
                               \\_/ [33m//
             [35m'''-.._.-'''-.._.. [33m-(||)(')
                               ''''[0m
        '';
      }
    }
  '';
}
