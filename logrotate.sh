#!/bin/bash

if [ $(id -u) != 0 ]; then
  echo "Script can only be run by root!"; exit 1;
fi

if [ $# != 1 ]; then
  echo "Usage: $0 /path/to/location"; exit 2;
fi

path=$1

echo "Getting log files greater than threshold which is 11MB"
sudo find $path -size +11M > $pathfilelist.txt

echo "Zipping below files into one !"
cat $path/filelist.txt
tar -cvf `column $path/filelist.txt` | gzip > $path/"zipped_log_$(date +%F_%R)"
rm -f $path/filelist.txt
echo "Sending mail to system owners ..."
mail -s "Attention: Some oversized log files were zipped!" your@email.com
