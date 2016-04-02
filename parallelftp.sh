#!/bin/bash

echo "PLEASE ENSURE THIS SCRIPT IS BEING RUN AS ROOT AND PUBLIC KEYS FOR SSH HAS BEEN COPIED TO REMOTE HOST."

begin=$(date +"%s")

read -p "Enter source directory: " srcdir
read -p "Enter destination directory: " destdir
read -p "Provide Username@IPAddress: " remotehost

rm /var/error.txt /var/output.txt > /dev/null
touch /var/error.txt /var/output.txt

echo "Starting execution of threads at: " $(date)
echo "****************************************************"
if [ -d $destdir ]; then
  echo "Destination directory found. Proceeding ..."
else
  echo "Creating Destination directory ..."
  ssh $remotehost mkdir -p $destdir
fi

cd $srcdir && ls $srcdir | parallel -v -j8 rsync -raz --progress {} $remotehost:$destdir{} 2> /var/error.txt > /var/output.txt

if [ "$?" = "0" ]; then
	echo "echo "All threads complete at: " $(date)"
	echo "Please check /var/output.txt for output"
else
	echo "Error copying files. Please check /var/error.txt for errors." 
	exit 1
fi

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for Script Execution."
echo "****************************************************" 
