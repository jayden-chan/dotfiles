# Arch Installation Instructions

# 1. Install Arch Linux
Follow the [official instructions](https://wiki.archlinux.org/title/installation_guide)
for installing Arch Linux. When performing the pacstrap step choose the following
packages: `base base-devel linux-lts linux-firmware linux-lts-headers git networkmanager
vi zsh tmux nodejs-lts-fermium`.

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

1. Install some dependencies:
```bash
# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# rust (toolchain needs to be set up before installing programs)
yay -S rustup
rustup toolchain install stable

# st
git clone https://github.com/jayden-chan/st
cd st
sudo make clean install
```

2. Set up the home directory and dotfiles:
```bash
mkdir Documents Downloads Videos Pictures
mkdir Documents/Git
cd Documents/Git
git clone https://github.com/jayden-chan/dotfiles
cd dotfiles
yay -Sy
yay -S $(./scripts/p.js verify | tr '\n' ' ')
```

3. Enable LightDM so we can actually log in
```
systemctl enable lightdm
```
