{
  pkgs,
  config-vars,
  ...
}:

let
  signing-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAqwiL56RIzEG55t2aa9ruLHBIBuo27mSkXU4/T19iwL";
in
{
  programs.git = {
    enable = true;

    signing.key = signing-key;

    hooks = {
      commit-msg = pkgs.writeShellScript "git-hook-commit-msg" ''
        set -euo pipefail

        args=("commit")
        if [ "$(git config get gitcheck.allow-initials)" = "true" ]; then
            args+=("--allow-initials")
        fi
        git-check "''${args[@]}" < "$1"
      '';

      pre-push = pkgs.writeShellScript "git-hook-pre-push" ''
        set -euo pipefail

        zero=$(git hash-object --stdin </dev/null | tr '0-9a-f' '0')

        while read -r local_ref local_oid remote_ref remote_oid
        do
            if test "$local_oid" = "$zero"; then
                # No need to check any commits if the push is a deletion
                exit 0
            else
                if test "$remote_oid" = "$zero"; then
                    # New branch, examine all commits
                    range="$local_oid"
                else
                    # Update to existing branch, examine new commits
                    range="$remote_oid..$local_oid"
                fi

                args=("commit" "--pushing")
                if [ "$(git config get gitcheck.allow-initials)" = "true" ]; then
                    args+=("--allow-initials")
                fi

                for commit in $(git rev-list "$range"); do
                    git show --pretty=format:%B --no-patch "$commit" | git-check "''${args[@]}"
                done
            fi
        done
      '';
    };

    settings = {
      user = {
        email = config-vars.email;
        name = "${config-vars.name} ${config-vars.last-name}";
      };

      diff.colorMoved = "default";
      init.defaultBranch = "main";
      pager.branch = false;
      pull.rebase = true;
      rebase.autoStash = true;
      tag.gpgSign = true;
      rerere.enabled = true;

      gpg = {
        format = "ssh";

        ssh.allowedSignersFile = "${pkgs.writeText "git-ssh-allowed-signers" ''
          ${config-vars.email} ${signing-key}
        ''}";
      };

      push = {
        default = "simple";
        autoSetupRemote = true;
        followTags = true;
      };

      core = {
        abbrev = "8";
        editor = "nvim";
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";

        excludesfile = "${pkgs.writeText "git-excludes-file"
          # gitignore
          ''
            node_modules
            *.swp
            *.tsbuildinfo

            .null-ls-root
            .null-ls-enable-eslint
            .git-ignored-general

            ##### Linux OS ignores

            # temporary files which can be created if a process still has a handle open of a deleted file
            .fuse_hidden*

            # KDE directory preferences
            .directory

            # Linux trash folder which might appear on any partition or disk
            .Trash-*

            # .nfs files are created when an open file is removed but is still being accessed
            .nfs*

            ##### MacOS Ignores

            # General
            .DS_Store
            .AppleDouble
            .LSOverride

            # Icon must end with two \r
            Icon

            # Thumbnails
            ._*

            # Files that might appear in the root of a volume
            .DocumentRevisions-V100
            .fseventsd
            .Spotlight-V100
            .TemporaryItems
            .Trashes
            .VolumeIcon.icns
            .com.apple.timemachine.donotpresent

            # Directories potentially created on remote AFP share
            .AppleDB
            .AppleDesktop
            Network Trash Folder
            Temporary Items
            .apdisk
          ''
        }";
      };

      commit = {
        gpgSign = true;
        verbose = true;
        template = "${pkgs.writeText "git-commit-template" ''

          # |<----  Using a Maximum Of 50 Characters  ---->|
          # <type>[optional scope]: <description>
          #
          # fix: a commit of the type fix patches a bug in your codebase
          # feat: a commit of the type feat introduces a new feature to the codebase
          #
          # BREAKING CHANGE: a commit that has a footer BREAKING CHANGE:, or appends a !
          # after the type/scope, introduces a breaking API change. A BREAKING CHANGE can
          # be part of commits of any type.
          #
          # other types: build, chore, ci, docs, style, refactor, perf, test

          # |<----   Try To Limit Each Line to a Maximum Of 72 Characters   ---->|

          # --- COMMIT END ---
          # Remember to
          #    Capitalize, imperative, no period, blank line between subject
          #    Use the body to explain what and why vs. how
          # Can use multiple lines with "-" or "*" for bullet points in body
          # -----------------
        ''}";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      features = "decorations";
      line-numbers = false;
      side-by-side = true;
      syntax-theme = "ansi";
      plus-style = "syntax #213620";
      minus-style = "syntax #3c1e20";
      paging = "always";

      interactive = {
        keep-plus-minus-markers = false;
      };

      decorations = {
        commit-decoration-style = "bold yellow box ul";
        file-style = "bold yellow ul";
        file-decoration-style = "bold red box ul";
        hunk-header-decoration-style = "cyan box ul";
      };
    };
  };
}
