#!/bin/bash

threshold="11M"

if [ $# != 1 ]; then
  echo "Usage: $0 /path/to/location"; exit 1;
fi

$1 = path
echo "Getting log files greater than threshold which is 11MB"
for i in `ls $path`; do
  size=`sudo du -sh $i | awk '{print $1}'`
    if [ "$size" -ge "$threshold" ] || [ "$size" -eq "$threshold" ];do
      cd $path
      echo $"sudo du -sh $i | awk '{print $2}'" | tee -a filelist.txt
    else
      continue
    fi
done
echo "Zipping below files into one ..."
cat filelist.txt
tar -cf `column filelist.txt` | gzip > zipped_log_$date
echo "Sending mail to system owners"
mail -s "Attention: Some oversized log files were zipped!" your@email.com
