#!/bin/bash

threshold="11000K"

if [ $# != 1 ]; then
  echo "Usage: $0 /path/to/location"; exit 1;
fi

path=$1

echo "Getting log files greater than threshold which is 11MB"
cd $path
touch filelist.txt

for i in `ls $path`; do
  size=`sudo du -h $path/$i | awk '{print $1}'`
  res=`echo "$size $threshold" | awk '{ if($1 > $2) print "Size Exceeds"; else print "Size Normal" }'`
  if [ "$res" == "Size Exceeds" ]
  then
    echo $"sudo du -h $i | awk '{print $2}'" | tee -a filelist.txt
  else
    continue
  fi
done
echo "Zipping below files into one !"
cat filelist.txt
tar -cf `column filelist.txt` | gzip > "zipped_log_$(date +%F_%R)"
rm -f filelist.txt
echo "Sending mail to system owners ..."
mail -s "Attention: Some oversized log files were zipped!" your@email.com
