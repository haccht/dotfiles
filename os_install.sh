#!/bin/bash

if [ -v $USERNAME ]; then
  echo 'USERNAME must be defined.';
  exit 1;
fi

# defaults
[ -v $SWAPSIZE ] && SWAPSIZE=32G
[ -v $HOSTNAME ] && HOSTNAME=arch

echo 'SWAPSIZE: ' $SWAPSIZE
echo 'HOSTNAME: ' $HOSTNAME
echo 'USERNAME: ' $USERNAME
echo
echo 'All partitions will be removed.'
read -p 'Are you sure to continue the installation? [y/n]: ' YN_CONTINUE
[ "$YN_CONTINUE" != "y" ] && exit

set -eux

# Update the system clock
timedatectl set-ntp true

# Partitioning
cat /proc/partitions | grep -E 'sda.+' | awk '{ print $2 }' | xargs -I{} parted -s /dev/sda rm {}
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart primary fat32 1MiB 256MiB 
parted -s /dev/sda set 1 boot on
parted -s /dev/sda set 1 esp on
parted -s /dev/sda mkpart primary 256MiB 512MiB
parted -s /dev/sda mkpart primary 512MiB 100%

# Filesystems
mkfs.vfat -F32 /dev/sda1

cryptsetup luksFormat /dev/sda2
cryptsetup luksOpen /dev/sda2 cryptboot
mkfs.ext4 /dev/mapper/cryptboot

cryptsetup luksFormat /dev/sda3
cryptsetup luksOpen /dev/sda3 lvm
pvcreate /dev/mapper/lvm
vgcreate arch /dev/mapper/lvm
lvcreate -L $SWAPSIZE arch -n swap
lvcreate -l +100%FREE arch -n root
mkswap -L swap /dev/mapper/arch-swap
mkfs.ext4 /dev/mapper/arch-root

mount /dev/mapper/arch-root /mnt
mkdir /mnt/boot
mount /dev/mapper/cryptboot /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

swapon /dev/mapper/arch-swap

# Mirrors
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak 
cat <<EOF > /etc/pacman.d/mirrorlist
##
## Arch Linux repository mirrorlist
## Generated on 2018-12-01
##

## Japan
Server = https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/\$repo/os/\$arch
Server = https://jpn.mirror.pkgbuild.com/\$repo/os/\$arch
Server = https://mirrors.cat.net/archlinux/\$repo/os/\$arch
EOF

# Install the base system
pacstrap -i /mnt base base-devel net-tools wireless_tools dialog wpa_supplicant grub efibootmgr sudo openssh git
genfstab -U -p /mnt >> /mnt/etc/fstab

# Workaround
# https://bugs.archlinux.org/task/61040
# https://bbs.archlinux.org/viewtopic.php?pid=1820949
mkdir /mnt/hostlvm
mount --bind /run/lvm /mnt/hostlvm

# Base configuration tasks
cat <<EOF > /mnt/root/base_configuration_tasks.sh
set -eux

passwd

export LANG=en_US.UTF-8
echo \$LANG UTF-8 >> /etc/locale.gen
echo LANG=\$LANG > /etc/locale.conf
locale-gen

rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc --utc

echo $HOSTNAME > /etc/hostname
systemctl enable dhcpcd.service

sed -i 's/^HOOKS=.*/HOOKS="base udev autodetect modconf block keyboard encrypt lvm2 resume filesystems fsck"/' /etc/mkinitcpio.conf
mkinitcpio -p linux

dd bs=512 count=8 if=/dev/urandom of=/crypto_keyfile.bin
cryptsetup luksAddKey /dev/sda2 /crypto_keyfile.bin
chmod 000 /crypto_keyfile.bin
echo "cryptboot /dev/sda2 /crypto_keyfile.bin luks" >> /etc/crypttab

# Workaround
# https://bugs.archlinux.org/task/61040
# https://bbs.archlinux.org/viewtopic.php?pid=1820949
ln -s /hostlvm /run/lvm

echo GRUB_ENABLE_CRYPTODISK=y >> /etc/default/grub
ROOTUUID=\$(blkid /dev/sda3 | awk '{print \$2}' | cut -d '"' -f2)
sed -i "s/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX=\"cryptdevice=UUID="\$ROOTUUID":lvm:allow-discards root=\/dev\/mapper\/arch-root resume=\/dev\/mapper\/arch-swap\"/" /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck
grub-mkconfig -o /boot/grub/grub.cfg
chmod -R g-rwx,o-rwx /boot

# for VirtualBox
mkdir -p /boot/efi/EFI/boot
cp /boot/efi/EFI/grub/grubx64.efi /boot/efi/EFI/boot/bootx64.efi

groupadd wheel
useradd -U -m \
        -G wheel \
        -s /bin/bash \
        $USERNAME
passwd $USERNAME
EOF
chmod +x /mnt/root/base_configuration_tasks.sh
arch-chroot /mnt /root/base_configuration_tasks.sh
rm -rf /mnt/tmp/base_configuration_tasks.sh

umount /mnt/hostlvm
rm -r /mnt/hostlvm

umount -R /mnt
reboot
