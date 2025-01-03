#!/bin/bash

# Update the system
sudo pacman -Syyu

# Installing gaming package from CachyOS
ensure_installed pacman nodejs lenovolegionlinux cachyos-gaming-meta python-pynvim  xclip xsel  wl-clipboard appmenu-gtk-module libdbusmenu-glib qt5ct wget unzip gum rsync git curl realtime-privileges libvoikko hspell nuspell hunspell aspell
ensure_installed pacman ttf-fantasque-nerd  ttf-font-awesome otf-font-awesome noto-fonts-emoji noto-fonts awesome-terminal-fonts ttf-fira-sans ttf-hack

# Check user is in realtime group
if cat /etc/group | grep $USER | grep -q realtime; then
    echo "User is already in realtime group."
else
    echo "Adding user to realtime group..."
    sudo gpasswd -a $USER realtime
    echo "User is now in realtime group."
fi

# Installing VSCode
ensure_installed paru visual-studio-code-bin ryzenadj


# Update HandleLidSwitch to ignore in logind.conf
LOGIND_CONF="/etc/systemd/logind.conf"

# Check if HandleLidSwitch=ignore is already set
if grep -q '^HandleLidSwitch=ignore' "$LOGIND_CONF"; then
    echo "HandleLidSwitch is already set to ignore."
else
    echo "Updating HandleLidSwitch to ignore in $LOGIND_CONF..."
    sudo sed -i 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' "$LOGIND_CONF"

    # Check if the line was updated or needs to be added
    if ! grep -q '^HandleLidSwitch=ignore' "$LOGIND_CONF"; then
        echo "HandleLidSwitch=ignore" | sudo tee -a "$LOGIND_CONF"
    fi

    echo "HandleLidSwitch is now set to ignore."
    echo "Restarting systemd-logind service..."
    #sudo systemctl restart systemd-logind
fi

# Check if rfkill-unblock@all systemd service is enabled or not
if systemctl is-active --quiet rfkill-unblock@all; then
    echo "rfkill-unblock@all is already active."
else
    echo "Enabling rfkill-unblock@all..."
    sudo systemctl enable --now rfkill-unblock@all || {
        echo "Failed to enable and start rfkill-unblock@all."
        exit 1
    }
    echo "rfkill-unblock@all started and enabled."
fi
