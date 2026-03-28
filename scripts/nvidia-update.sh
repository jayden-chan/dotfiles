#!/usr/bin/env bash

nix_code_block="$(curl --silent https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/nixos-unstable/pkgs/os-specific/linux/nvidia-x11/default.nix \
    | rg --multiline 'production = generic \{((?s:.*?)).*?};' --only-matching --replace='$1' --color=never)"

version="$(echo "$nix_code_block" | rg 'version = "(.*?)";' --only-matching --replace='$1' --color=never)"

echo 1>&2 "Version: $version"

script_pattern="\\[\"${version}\"]='(.*?)'"

fbc_patch="$(curl --silent https://raw.githubusercontent.com/keylase/nvidia-patch/refs/heads/master/patch-fbc.sh \
    | rg "$script_pattern" --only-matching --replace='$1' --color=never)"

echo 1>&2 "FBC patch: $fbc_patch"
if [ "$fbc_patch" = "" ]; then
    echo 1>&2 "Error: Failed to locate FBC patch code in patch-fbc.sh script"
    exit 1
fi

enc_patch="$(curl --silent https://raw.githubusercontent.com/keylase/nvidia-patch/refs/heads/master/patch.sh \
    | rg "$script_pattern" --only-matching --replace='$1' --color=never)"

echo 1>&2 "Encoder patch: $enc_patch"
if [ "$enc_patch" = "" ]; then
    echo 1>&2 "Error: Failed to locate encoder patch code in patch.sh script"
    exit 1
fi

code_snippet="
  nvidia-package =
    (
      (config.boot.kernelPackages.nvidiaPackages.mkDriver {
        ${nix_code_block}
      }).overrideAttrs
      (
        { version, preFixup ? \"\", ... }:
        {
          preFixup = preFixup + ''
            sed -i '${fbc_patch}' \$out/lib/libnvidia-fbc.so.\${version}
            sed -i '${enc_patch}' \$out/lib/libnvidia-encode.so.\${version}
          '';
        }
      )
    );"

echo "$code_snippet" | xclip -selection c
echo "Copied code snippet to clipboard"
