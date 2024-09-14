{ ... }:

{
  imports = [ ../../common/home.nix ];

  home.stateVersion = "24.05";

  programs.autorandr.profiles.main = {
    config = {
      "HDMI-0" = {
        enable = true;
        mode = "1920x1080";
        position = "0x0";
        rate = "144.00";
        crtc = 0;
        rotate = "left";
      };
      "DP-2" = {
        enable = true;
        mode = "1920x1080";
        position = "1080x350";
        rate = "240.00";
        crtc = 0;
        primary = true;
      };
    };
    fingerprint = {
      # LG Electronics LG ULTRAGEAR
      "HDMI-0" = "00ffffffffffff001e6d025c73f6000008210103803c2278eaab45a456509e27125054210800d1c00101010101010101010101010101288380a0703829403020350058542100001a023a801871382d40582c450058542100001a000000fd0030901eaa22000a202020202020000000fc004c4720554c545241474541520a0116020328f1230907074b010203041112131f903f4065030c0010006d1a00000205309000044a2e4a2e866f80a0703840403020350058542100001afe5b80a0703835403020350058542100001a000000ff000a202020202020202020202020000000000000000000000000000000000000000000000000000000000000000000f5";
      # BenQ ZOWIE XL LCD
      "DP-2" = "00ffffffffffff0009d1777f01010101031f0104a53c22783fa265a454519d26105054a56b80d1c081c081008180a9c0b30081bc0101023a801871382d40582c450056502100001e000000ff0045424d314d3030353035534c30000000fd0030f0ffff3c010a202020202020000000fc005a4f57494520584c204c43440a012b020318f14b010203040590111213141f2309070783010000fe5b80a0703835403020350056502100001a866f80a0703840403020350056502100001a5a8780a070384d403020350056502100001a23e88078703887401c20980c56502100001a9cc700085200a0407490370056502100001c00000000000000000000000000b8";
    };
  };
}
