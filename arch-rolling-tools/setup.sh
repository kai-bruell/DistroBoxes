#!/bin/bash
set -e

CHAOTIC_AUR=(
    neovim
)

PARU=(
    # Pakete aus dem AUR (werden kompiliert)
)

EXPORT_BINS=(
    /usr/bin/nvim
)

# Setup Chaotic-AUR
pacman-key --init
pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
pacman-key --lsign-key 3056513887B78AEB
pacman -U --noconfirm \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' \
    'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

printf '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist\n' >> /etc/pacman.conf

pacman -Sy --noconfirm paru

# Pakete installieren
[[ ${#CHAOTIC_AUR[@]} -gt 0 ]] && pacman -S --noconfirm "${CHAOTIC_AUR[@]}"
[[ ${#PARU[@]} -gt 0 ]] && sudo -u "$(getent passwd 1000 | cut -d: -f1)" -H paru -S --noconfirm "${PARU[@]}"

# Binaries auf den Host exportieren
USER_NAME="$(getent passwd 1000 | cut -d: -f1)"
for bin in "${EXPORT_BINS[@]}"; do
    sudo -u "$USER_NAME" -H distrobox-export --bin "$bin"
done
