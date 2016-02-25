#!/bin/bash
for stx in $(cat /home/luckee/Downloads/cdr.csv | tr "," " " | awk '{print $2}');do

if [ $stx -ge 300 ]
then

       sed -n $(stx)p   /home/luckee/Downloads/cdr.csv
fi
done
