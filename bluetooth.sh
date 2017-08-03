echo "Downloading firmware driver..."
sleep 1
#wget https://www.dropbox.com/s/r2pb41rhx65t9zi/BCM20702A0-0a5c-216f.hcd
#sudo cp BCM20702A0-0a5c-216f.hcd /lib/firmware/brcm/
echo "Repairing bluetooth ..."
sudo modprobe -r btusb
sudo modprobe btusb
echo "Will sleep for 10 seconds. Begin pairing now !"
i=1
while [ $i -le 10 ]; do 
    echo $i 
    sleep 1 
    i=$(( $i + 1 )) 
done
pactl load-module module-bluetooth-discover
retval=$?
if [ $retval -eq 0 ]; then
    echo "Bluetooth should be functional now!"
else 
    echo "Setup failed ..."
fi 
