echo "Downloading firmware driver..."
sleep 1
wget https://www.dropbox.com/s/r2pb41rhx65t9zi/BCM20702A0-0a5c-216f.hcd
sudo cp BCM20702A0-0a5c-216f.hcd /lib/firmware/brcm/
echo "Repairing bluetooth ..."
sudo modprobe -r btusb
sudo modprobe btusb
echo "Bluetooth should be functional now!"

