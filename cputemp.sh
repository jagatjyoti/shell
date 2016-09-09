#!/bin/bash

# Check if package sensors (for Ubuntu) is installed, if not install it
dpkg -l | grep -i sensors > /dev/null

if [ "$?" == "0" ]; then
  echo "Package sensors already installed on system. Analyzing temperature!"
else
  sudo apt-get install sensors && echo "Package sensors now installed"
fi

# Set threshold temperature
threshold="+80.0°C"

# Check if temp has reached threshold, trigger mail
tempnow=$(sensors | sed -n '20p' | awk '{print $NF}')

res=`echo "$tempnow $threshold" | awk '{ if($1 > $2) print "Exceeds"; else print "Normal" }'`

if [ "$res" == "Exceeds" ]
then
  echo "Temperature exceeds threshold. Triggering mail to system owners..."
  mail -s "CPU temperature too high on system" abc@xyz.com
elif [ "$res" == "Normal" ]
then
  echo "Temperature under limit. Ignoring countermeasures!"
else
  echo "Unable to determine value"
fi
