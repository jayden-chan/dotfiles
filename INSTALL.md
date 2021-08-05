# Linux System Setup Instructions

# 1. Install Arch Linux
Follow the [official instructions](https://wiki.archlinux.org/title/installation_guide)
for installing Arch Linux. When performing the `pacstrap` step choose the following
packages: `base base-devel linux-lts linux-firmware git networkmanager vi zsh tmux
nodejs-lts-fermium`.

**Stop before the final step of rebooting.**

# 2. Arch Installation Extras
1. Enable the `NetworkManager` systemd service.
2. Install `yay`:
```bash
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```
3. Create a new user:
```bash
useradd -m -s /bin/zsh jayden
passwd jayden
```

4. Reboot

# 3. Configuring the system
After rebooting login as the new user with the password that was set.

1. Set up the home directory and dotfiles:
```bash
mkdir -p Documents/Git Downloads Videos Pictures
cd Documents/Git

git clone https://github.com/jayden-chan/dotfiles
cd dotfiles

# Make sure our env vars are set up correctly for the next steps
./scripts/deploy.sh --env
```

2. Install some dependencies:
```bash
# rust (toolchain needs to be set up before installing programs)
yay -S rustup
rustup toolchain install stable

# st
git clone https://github.com/jayden-chan/st
cd st
sudo make clean install
```

3. Install programs:
```bash
yay -Sy
yay -S $(./scripts/p.js missing | tr '\n' ' ')
```

3. Enable LightDM so we can actually log in
```
systemctl enable lightdm
```

4. Reboot the system. Nearly everything should be set up now.
