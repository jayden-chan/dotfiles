# Installing NixOS

1. Load into the NixOS installation environment via bootable USB
2. Start a terminal and log in as root
3. Run `fdisk -l` and find the disk to install onto

4. Partition the disk as follows:
    * Partition 1: 1GB EFI System Partition
    * Partition 2: All remaining space default partition type

5. Construct the LVM-on-LUKS file system setup
```bash
LUKS_ROOT_DEVICE=/dev/nvme1n1p2
BOOT_DEVICE=/dev/nvme1n1p1

cryptsetup luksFormat $LUKS_ROOT_DEVICE
cryptsetup open $LUKS_ROOT_DEVICE cryptlvm

pvcreate /dev/mapper/cryptlvm

vgcreate MyVolGroup /dev/mapper/cryptlvm

lvcreate -L 8G -n nixos-swap MyVolGroup
lvcreate -l '100%FREE' -n nixos-root MyVolGroup
```

6. Create the file systems on the logical volumes
```bash
mkfs.vfat -n nixos-boot $BOOT_DEVICE

mkfs.ext4 -L nixos-root /dev/MyVolGroup/nixos-root

mkswap -L nixos-swap /dev/MyVolGroup/nixos-swap

swapon /dev/MyVolGroup/nixos-swap
```

7. Mount the file systems and prep for install
```bash
mount /dev/MyVolGroup/nixos-root /mnt
mkdir /mnt/boot
mount -o umask=077 $BOOT_DEVICE /mnt/boot
```

8. Generate a config
```bash
nixos-generate-config --root /mnt
```

9. Ensure the boot file system in `hardware-configuration.nix` is correct
```nix
fileSystems."/boot" =
  { device = "/dev/disk/by-label/nixos-boot";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
```

10. Make required modifications to the generated `configuration.nix`
```nix
boot.initrd.luks.devices = {
  root = {
    device = "<LUKS_ROOT_DEVICE>";
    preLVM = true;
  };
};

networking.hostName = "grace";
networking.networkmanager.enable = true;
time.timeZone = "America/Edmonton";
i18n.defaultLocale = "en_CA.UTF-8";
environment.systemPackages = with pkgs; [
  neovim
];

services.xserver.enable = false;
# Also delete any other xserver configs, our first installation will be headless
```

11. Perform the install
```bash
nixos-install
```

12. Reboot
13. Log in as root
14. Copy dotfiles nix config to /etc/nixos
15. Make any required merges to `configuration.nix`
16. Rebuild with `nixos-rebuild switch --flake '.#'`
17. Reboot
18. Log in as root
19. Set password for non-root user with `passwd jayden`
20. Log in as non-root
21. Profit
