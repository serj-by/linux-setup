# Instant fnmode change
echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
# Permanent fnmode change
echo "options hid_apple fnmode=2" | sudo tee /etc/modprobe.d/hid_apple.conf
sudo update-initramfs -u -k all
