#! /bin/bash

sudo pacman -S pacman-mirrors --noconfirm
sudo pacman-mirrors -c Japan Australia Singapore

sudo pacman -S git vim tmux unzip yay --noconfirm

sudo sed -i "s/^#en_US.UTF-8/en_US.UTF-8/g" /etc/locale.gen
sudo sed -i "s/^#ja_JP.UTF-8/ja_JP.UTF-8/g" /etc/locale.gen
sudo locale-gen

yay -S rofi feh i3blocks i3lock-fancy-git i3lock-color-git google-chrome fcitx fcitx-im fcitx-mozc fcitx-configtool --noconfirm
yay -S noto-fonts-cjk noto-fonts-emoji ttf-myricam ttf-font-awesome awesome-terminal-fonts --noconfirm

git clone https://github.com/haccht/ditfiles.git ~/dotfiles
sh ~/dotfiles/bootstrap.sh

mkdir -p ~/.config/i3 ~/.config/rofi ~/.config/dunst
ln -snfv ~/dotfiles/config/i3/config ~/.config/i3/config
ln -snfv ~/dotfiles/config/i3/i3blocks.conf ~/.config/i3/i3blocks.conf
ln -snfv ~/dotfiles/config/rofi/config ~/.config/rofi/config
ln -snfv ~/dotfiles/config/dunst/config ~/.config/dunst/config

git clone https://github.com/vivien/i3blocks-contrib ~/.config/i3/i3blocks-contrib
sudo cp -f ~/dotfiles/config/i3/i3exit.sh /usr/bin/i3exit
sudo cp -f ~/dotfiles/config/i3/i3lock\@.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable i3lock@${USER}.service

yay -S docker docker-compose qemu libvirt virt-manager ebtables vagrant
yay -S networkmanager-l2tp bind-tools samba nfs-utils
yay -S mpv skype handbrake handbrake-cli libdvdread libdvdcss libdvdnav asunder brasero android-tools wireshark-cli wireshark-qt

sudo gpasswd -a haccht docker
sudo gpasswd -a haccht libvirt
sudo gpasswd -a haccht optical
sudo systemctl start docker   && sudo systemctl enable docker
sudo systemctl start libvirtd && sudo systemctl enable libvirtd

yay -S lightdm-webkit2-greeter --noconfirm
sudo git clone https://github.com/paysonwallach/aqua-lightdm-webkit-theme /usr/share/lightdm-webkit/themes/aqua

sudo sed -i "s/^greeter-session/greeter-session=lightdm-webkit2-greeter/g" /etc/lightdm/lightdm.conf
sudo sed -i "s/^webkit_theme/webkit_theme=aqua/g" /etc/lightdm/lightdm-webkit2-greeter.conf

yay -S xkeysnail --noconfirm
sudo groupadd uinput
sudo useradd -G input,uinput -s /sbin/nologin xkeysnail

sudo cp ~/dotfiles/xkeysnail.py /etc/xkeysnail/config.py
echo 'KERNEL=="uinput", GROUP="uinput"' | sudo tee /etc/udev/rules.d/40-udev-xkeysnail.rules
echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
echo 'haccht ALL=(ALL) ALL, (xkeysnail) NOPASSWD: /usr/bin/xkeysnail' | sudo tee /etc/sudoers.d/20-xkeysnail

cat <<EOL > ~/.config/i3/xkeysnail.sh
#! /bin/sh
if [ -x /usr/bin/xkeysnail ]; then
  xhost +SI:localuser:xkeysnail
  sudo -u xkeysnail /usr/bin/xkeysnail /etc/xkeysnail/config.py &
fi
EOL
chmod a+x ~/.config/i3/xkeysnail.sh

cat <<EOL > ~/.config/i3/disable-touchpad.sh
#! /bin/sh
prop=$(xinput | grep "Synaptics TM3289-002" | sed -r 's/^.*id=(\S+).*$/\1/')
xinput set-prop ${prop} --type=int --format=8 "Device Enabled" 0
EOL
chmod a+x > ~/.config/i3/disable-touchpad.sh
