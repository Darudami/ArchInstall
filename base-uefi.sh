#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Eastern /etc/localtime
hwclock --systohc
sed -i '165s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
#echo "KEYMAP=de_CH-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
echo root:password | chpasswd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils gvfs gvfs-smb nfs-utils inetutils dnsutils bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack rsync reflector acpi acpi_call tlp iptables-nft ipset firewalld sof-firmware nss-mdns acpid terminus-font

# pacman -S grub
# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

# Uncomment for grub install
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=ARCH --removable #change the directory to /boot/efi is you mounted the EFI partition at /boot/efi
# grub-mkconfig -o /boot/grub/grub.cfg

bootctl --path=/boot install

echo "default arch" > /boot/loader/loader.conf
echo "timeout 3" >> /boot/loader/loader.conf
echo "console-mode max" >> /boot/loader/loader.conf
echo "editor no" >> /boot/loader/loader.conf

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /intel-ucode.img" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options root=UUID=$(blkid -s UUID -o value /dev/vda2) rootflags=subvol=@ rw" >> /boot/loader/entries/arch.conf

EOF

systemctl enable NetworkManager
systemctl enable bluetooth
# systemctl enable cups.service
# systemctl enable sshd
systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
# systemctl enable libvirtd
systemctl enable firewalld
systemctl enable acpid

useradd -m damian
echo damian:password | chpasswd
# usermod -aG libvirt damian

echo "damian ALL=(ALL) ALL" >> /etc/sudoers.d/damian

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

