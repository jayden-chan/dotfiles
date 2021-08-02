# Filename of the dotenv file to look for
: ${ZSH_DOTENV_FILE:=.env}

source_env() {
  if [[ ! -f "$ZSH_DOTENV_FILE" ]]; then
    return
  fi

  # test .env syntax
  zsh -fn $ZSH_DOTENV_FILE || echo "dotenv: error when sourcing '$ZSH_DOTENV_FILE' file" >&2

  setopt localoptions allexport
  source $ZSH_DOTENV_FILE
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
