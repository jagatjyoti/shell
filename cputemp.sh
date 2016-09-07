#!/bin/bash

# Check if package sensors (for Ubuntu) is installed, if not install it
dpkg -l | grep -i sensors

if [ "$?" == "0" ]; then
  echo "Package sensors already installed on system. Analyzing temperature!"
else
  sudo apt-get install sensors && echo "Package sensors now installed"
fi

# Set threshold temperature
threshold=+80.0°C

# Check if temp has reached threshold, trigger mail
tempnow=$(sensors | sed -n '20p' | awk '{print $NF}')

if [ "$tempnow" -ge "$threshold" ]; then
  echo "Temperature exceeds threshold. Triggering mail to system owners..."
  mail -s "CPU temperature too high on system" abc@xyz.com
else
  echo "Temperature under limit. Ignoring countermeasures!"
fi

