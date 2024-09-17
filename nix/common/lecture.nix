{ config-vars, ... }:

{
  # setup the sudoers lecture
  security.sudo.extraConfig = ''
    Defaults lecture = always
    Defaults lecture_file = ${config-vars.dotfiles-dir}/misc/sudoers.lecture
  '';
}
