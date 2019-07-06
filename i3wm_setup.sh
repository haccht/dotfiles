#! /bin/bash

sudo pacman -S git vim tmux unzip yay --noconfirm
git clone https://github.com/haccht/dotfiles ~/dotfiles
yes | sh dotfiles/setup.sh

sudo sed -i "s/^#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
sudo sed -i "s/^#ja_JP.UTF-8/ja_JP.UTF-8/g" /etc/locale.gen
sudo locale-gen

yay -S rofi feh i3bloks i3lock-fancy google-chrome fcitx fcitx-im fcitx-mozc fcitx-configtool --noconfirm
yay -S noto-fonts-cjk noto-fonts-emoji ttf-myricam ttf-font-awesome awesome-terminal-fonts --noconfirm

mkdir -p ~/.config/i3 ~/.config/rofi ~/.config/dunst
ln -snfv ~/dotfiles/.config/i3/config       ~/.config/i3/config
ln -snfv ~/dotfiles/.config/i3/i3bloks.conf ~/.config/i3/i3blocks.conf
ln -snfv ~/dotfiles/.config/rofi/i3/config  ~/.config/rofi/config
ln -snfv ~/dotfiles/.config/dunst/i3/config ~/.config/dunst/config
git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3/i3blocks-contrib
sudo cp ~/dotfiles/.config/i3/i3lock.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable i3lock.service

yay -S docker docker-compose qemu libvirt virt-manager ebtables vagrant
yay -S networkmanager-l2tp bind-tools samba nfs-utils
yay -S mpv skype handbrake handbrake-cli libdvdread libdvdcss libdvdnav asunder brasero android-tools wireshark-cli wireshark-qt

sudo gpasswd -a haccht docker
sudo gpasswd -a haccht libvirt
sudo gpasswd -a haccht optical
sudo systemctl start libvirtd && sudo systemctl enable libvirtd

yay -S lightdm-webkit2-greeter --noconfirm
sudo git clone https://github.com/paysonwallach/aqua-lightdm-webkit-theme /usr/share/lightdm-webkit/themes/aqua

sudo sed -i "s/^greeter-session/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/^webkit_theme/webkit_theme=aqua/g" /etc/lightdm/lightdm-webkit2-greeter.conf

yay -S xkeysnail --noconfirm
sudo groupadd uinput
sudo useradd -G input,uinput -s /sbin/nologin xkeysnail

echo 'KERNEL=="uinput", GROUP="uinput"' | sudo tee /etc/udev/rules.d/40-udev-xkeysnail.rules
echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
echo 'haccht ALL=(ALL) ALL, (xkeysnail) NOPASSWD: /usr/bin/xkeysnail' | sudo tee /etc/sudoers.d/20-xkeysnail

cat <<EOL
#! /bin/sh
if [ -x /usr/bin/xkeysnail ]; then
  xhost +SI:localuser:xkeysnail
  sudo -u xkeysnail /usr/bin/xkeysnail /etc/xkeysnail/config.py &
fi
EOL > ~/bin/xkeysnail.sh
chmod a+x ~/bin/xkeysnail.sh
