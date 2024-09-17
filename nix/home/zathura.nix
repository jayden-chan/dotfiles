{ ... }:

{
  programs.zathura = {
    enable = true;
    mappings = {
      "j" = "scroll left";
      "i" = "scroll up";
      "k" = "scroll down";

      "K" = "scroll half-down";
      "I" = "scroll half-up";

      "<Right>" = "navigate next";
      "<Left>" = "navigate previous";
    };

    options = {
      "selection-clipboard" = "clipboard";
      "statusbar-home-tilde" = true;
      "guioptions" = "vh";
      "scroll-step" = 100;
      "scroll-page-aware" = true;
      "page-padding" = 8;
    };
  };
}
