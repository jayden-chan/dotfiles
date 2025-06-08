{ ... }:

{
  programs.lazygit = {
    enable = true;

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
      };

      update.method = "never";
      promptToReturnFromSubprocess = false;

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
        };
        files = {
          commitChangesWithEditor = "c";
          commitChanges = "C";
          ignoreFile = "h";
          amendLastCommit = "A";
          stashAllChanges = "S";
        };
      };

      git = {
        autoFetch = false;
        mainBranches = [
          "master"
          "main"
          "production"
        ];
        skipHookPrefix = "--wip--";
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
