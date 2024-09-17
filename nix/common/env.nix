{ config-vars, ... }:

{
  environment.sessionVariables = rec {
    # home directory cleanup
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_DESKTOP_HOME = "$HOME/.local/desktop";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";

    # home directory cleanup
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    CUDA_CACHE_PATH = "${XDG_CACHE_HOME}/nv";
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
    GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    GRIPHOME = "${XDG_CONFIG_HOME}/grip";
    GTK2_RC_FILES = "${XDG_CONFIG_HOME}/gtk-2.0/gtkrc";
    HISTFILE = "${XDG_STATE_HOME}/zsh/history";
    ICEAUTHORITY = "${XDG_CACHE_HOME}/ICEauthority";
    IPYTHONDIR = "${XDG_CONFIG_HOME}/jupyter";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
    KUBECACHEDIR = "${XDG_CACHE_HOME}/kube";
    LESS = "-RX";
    LESSHISTFILE = "-";
    NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
    SQLITE_HISTORY = "${XDG_DATA_HOME}/sqlite_history";
    SSB_HOME = "${XDG_DATA_HOME}/zoom";
    WGETRC = "$HOME/.config/wget/wgetrc";
    XCOMPOSECACHE = "${XDG_CACHE_HOME}/X11/xcompose";
    ZDOTDIR = "$HOME/.config/zsh";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";

    EDITOR = "nvim";
    TERMINAL = "st";
    BROWSER = "zen";
    COLORTERM = "truecolor";
    DOT = config-vars.dotfiles-dir;
    HOSTNAME = config-vars.host;

    # yikes
    DO_NOT_TRACK = "1";
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    GATSBY_TELEMETRY_DISABLED = "1";
    DENO_NO_UPDATE_CHECK = "1";
    GOPROXY = "direct";
    ARTILLERY_DISABLE_TELEMETRY = "true";

    PATH = [
      "$HOME/.local/bin"
      "${XDG_DATA_HOME}/cargo/bin"
      "$HOME/.local/bin"
      "$HOME/.nix-profile/bin"
      "$HOME/.cache/.bun/bin"
    ];
  };
}
