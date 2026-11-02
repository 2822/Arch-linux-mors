cat << 'EOF' > /setup.sh
#!/bin/bash
set -e

echo "=== 1. Configurando zona horaria y reloj ==="
ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
hwclock --systohc

echo "=== 2. Configurando Idioma y Localización ==="
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "es_MX.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=es_MX.UTF-8" > /etc/locale.conf

echo "=== 3. Nombre del Host ==="
echo "asus-k46" > /etc/hostname

echo "=== 4. Creando Usuario mors y Privilegios Sudo ==="
pacman -S --noconfirm sudo git base-devel networkmanager
useradd -m -G wheel mors
echo "mors:mors2822" | chpasswd
echo "root:mors2822" | chpasswd
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo "=== 5. Instalando Gestor de Arranque (GRUB) ==="
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo "=== 6. Habilitando Servicios Esenciales ==="
systemctl enable NetworkManager

echo "=== 7. Instalando Entorno Gráfico, DankMaterialShell, Zen Browser y OpenCode CLI ==="
# Instalación de Yay para paquetes del AUR
su - mors -c "git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && cd /tmp/yay-bin && makepkg -si --noconfirm"

# Instalación de utilidades gráficas, Zen Browser y OpenCode
su - mors -c "yay -S --noconfirm dankmaterialshell-git zen-browser-bin opencode-bin"

echo "=== Configuración completada con éxito ==="
EOF

chmod +x /setup.sh
/setup.sh
