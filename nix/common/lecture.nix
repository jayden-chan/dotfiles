{ config-vars, ... }:

{
  # setup the sudoers lecture
  security.sudo.extraConfig = ''
    Defaults lecture = always
    Defaults lecture_file = ${config-vars.home-dir}/.config/dotfiles/misc/sudoers.lecture
  '';
}
