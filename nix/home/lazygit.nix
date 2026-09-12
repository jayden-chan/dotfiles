{ config-vars, unstable, ... }:

{
  programs.lazygit = {
    enable = true;
    package = unstable.lazygit;

    settings = {
      gui = {
        commitHashLength = 0;
        splitDiff = "auto";
        nerdFontsVersion = "3";
        scrollHeight = 12;
        sidePanelWidth = 0.2;
        showListFooter = false;
        showBottomLine = false;
        showRandomTip = false;
        showFileTree = false;
        showCommandLog = false;
        mouseEvents = false;

        shrinkSidePanelsToContent = true;
        expandFocusedSidePanel = true;

        sidePanels = [
          [ "status" ]
          [
            "files"
            "worktrees"
          ]
          [
            "commits"
            "reflog"
          ]
          [
            "branches"
            "remotes"
            "tags"
          ]
          [ "stash" ]
        ];

        theme = {
          selectedLineBgColor = [ config-vars.theme.cursorline ];
        };
      };

      update.method = "never";
      promptToReturnFromSubprocess = false;
      notARepository = "quit";

      keybinding = {
        universal = {
          prevItem-alt = "i";
          nextItem-alt = "k";
          scrollLeft = "J";
          scrollRight = "L";
          prevBlock-alt = "j";
          nextBlock-alt = "l";
          scrollUpMain-alt1 = "I";
          scrollDownMain-alt1 = "K";

          suspendApp = "<disabled>";
        };
        files = {
          commitChangesWithEditor = "c";
          ignoreFile = "h";
          amendLastCommit = "A";

          copyFileInfoToClipboard = "<disabled>";
          commitChanges = "<disabled>";
        };
      };

      git = {
        autoFetch = false;
        disableForcePushing = true;
        mainBranches = [
          "master"
          "main"
          "production"
        ];
        skipHookPrefix = "--wip--";
        diffRenderers = [
          {
            command = "delta --dark --paging=never";
            colorArg = "always";
          }
        ];
      };
    };
  };
}
