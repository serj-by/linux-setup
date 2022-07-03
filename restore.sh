#!/bin/bash

# Make sure password is known
#sudo -k
sudo echo "Logged in as $USER..."
# Instant fnmode change
echo "Changing Fn keys to acts as Fn Kays by default for this session...".
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode && echo "Done."
# Permanent fnmode change
echo "Changing Fn keys to acts as Fn Kays by default for permanently...".
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf && echo "Done"
read -p "Update kernel (y/n)?" q;
if [[ $q =~ ^[Yy]$ ]]; then
    echo "Updating kernel...";
    sudo update-initramfs -u -k all && echo "Done";
else
    echo "Skipping kernel update..."
fi

read -p "Restore all DConf settings (y/n)?" q;
if [[ $q =~ ^[Yy]$ ]]; then
    echo "Cinnamon setting restoring...";
    sudo dconf load /org/cinnamon/ < root-all-dconf.txt && echo "Done. Press Ctrl+Alt+Esc to restart Cinnamon";
else
    echo "Skipping Cinnamon settings restore...";
fi

