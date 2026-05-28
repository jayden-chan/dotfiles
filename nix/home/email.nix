{
  config-vars,
  lib,
  pkgs,
  ...
}:

{
  accounts.email.accounts = {
    "${config-vars.email}" = {
      flavor = "fastmail.com";
      enable = true;
      primary = true;
      address = config-vars.email;
      userName = config-vars.email;
      realName = "${config-vars.name} ${config-vars.last-name}";

      passwordCommand = "${lib.getExe' pkgs.coreutils "cat"} /run/agenix/smtp-pass";

      aerc = {
        enable = true;
      };

      mbsync = {
        enable = true;
        create = "maildir";
        expunge = "both";
        remove = "none";
      };
    };
  };

  services.mbsync = {
    enable = true;
    # systemd.time(7) -- https://www.freedesktop.org/software/systemd/man/systemd.time.html
    # every 49 minutes
    frequency = "*:0/49";
  };

  programs.mbsync.enable = true;

  programs.aerc = {
    enable = true;

    extraConfig = {
      general.unsafe-accounts-conf = true;
      filters = {
        ".headers" = "colorize";
        "message/delivery-status" = "colorize";
        "message/rfc822" = "wrap -w 80 | colorize";
        "text/calendar" = "calendar";
        "text/html" = "html | colorize";
        "text/plain" = "wrap -w 80 | colorize";
      };
    };

    extraBinds = {
      messages = {
        k = ":next<Enter>";
        i = ":prev<Enter>";
        K = ":next-folder<Enter>";
        I = ":prev-folder<Enter>";
        o = ":view<Enter>";
        q = ":quit<Enter>";

        "$" = ":term<space>";
        "!" = ":term<space>";
        "|" = ":pipe<space>";

        "/" = ":search<space>";
        n = ":next-result<Enter>";
        N = ":prev-result<Enter>";
        A = ":archive flat<Enter>";
        "<Esc>" = ":clear<Enter>";

        T = ":toggle-threads<Enter>";
        zc = ":fold<Enter>";
        zo = ":unfold<Enter>";
        za = ":fold -t<Enter>";
        zM = ":fold -a<Enter>";
        zR = ":unfold -a<Enter>";
        "<tab>" = ":fold -t<Enter>";

        v = ":mark -t<Enter>";
        "<Space>" = ":mark -t<Enter>:next<Enter>";
        V = ":mark -v<Enter>";
      };

      view = {
        K = ":next<Enter>";
        I = ":prev<Enter>";
        q = ":close<Enter>";
        A = ":archive flat<Enter>";
        H = ":toggle-headers<Enter>";
        "|" = ":pipe<space>";
        l = ":next-part<Enter>";
        j = ":prev-part<Enter>";
        L = ":next<Enter>";
        J = ":prev<Enter>";
      };

      compose = {
        "<tab>" = ":next-field<Enter>";
        "<backtab>" = ":prev-field<Enter>";
      };

      "compose::editor" = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-Up>" = ":prev-field<Enter>";
        "<C-Down>" = ":next-field<Enter>";
      };

      terminal = {
        "$noinherit" = "true";
        "$ex" = "<C-x>";
        "<C-p>" = ":prev-tab<Enter>";
        "<C-n>" = ":next-tab<Enter>";
        "<C-PgUp>" = ":prev-tab<Enter>";
        "<C-PgDn>" = ":next-tab<Enter>";
      };
    };

    stylesets = {
      default = ''
        *.selected.bg = ${config-vars.theme.cursorline}
        selector_focused.fg = ${config-vars.theme.base00}
        title.fg = ${config-vars.theme.base00}
        msglist_marked.bg = ${config-vars.theme.base02}
        msglist_pill.fg = ${config-vars.theme.base00}
      '';
    };
  };
}
