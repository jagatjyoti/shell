#!/bin/bash

if [ $# != 1 ]; then
  echo "Usage: $0 /path/to/location"; exit 1;
fi

$1 = path
echo "Largest 10 files in `$path` are:"
sudo du -a /var | sort -n -r | head -n 10 | tee larfiles.txt

read -p "Do you want to delete these large files ? [y/n]"  response
if [ "$response" == "y" ]; then
  for file in larfiles.txt; do
      rm $file
  done
elif [ "$response" == "n" ]; then 
  echo "Files are untouched !"; exit 0;
else
  echo "Nothing to do"; exit 0;
fi
