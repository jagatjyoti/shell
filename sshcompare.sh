#!/bin/bash
 
#Logging
exec > >(tee -a /var/tmp/sshlog.txt)
 
#Usage message
if [ $# != 2 ]; then
  echo "Usage: $0 original_file file_to_copy"
  exit 1
fi
 
date +'%m/%d/%Y %H:%M:%S'
echo "-----------------------"
retval=$?
 
#Creating ssh_config backup file
if [[ -f $1.bkp ]]; then
  echo "Backup file exists"
else
  echo "Creating backup of Input file"
  cp $1 $1.bkp
fi
 
#Checking other file and updating original ssh file
while read -r line
do
  [[ -z $line || $line =~ ^#.*$ ]] && continue
  echo $line
  IFS=' ' read -ra ADDR <<< $line
  param1=${ADDR[0]}
  val1=${ADDR[1]}
  val2=$(grep $param1 $1 |grep -v ^# |awk '{print $2}')
  echo "Print  $param1 $val2"
  if [[ ( '$val2' != "" ) && ( '$val1' != '$val2' ) ]]
  then
     echo "Values are different hence updating config file"
   #commenting line from original file
     sed -i  '/^[[:space:]]*'$param1'/s/^/#/' $1
     [ $retval -eq 0 ] && echo "Commenting done" || echo "Error while Commenting"
   #appending new line after commented line
    sed -i "/$param1[[:space:]]*$val2$/a \
           $param1  $val1 " $1
    [ $retval -eq 0 ] && echo "Appending done" || echo "Error while Appending"
  elif [ '$val2' == "" ]
  then
     #sed -i '$ a $line'  $1
     echo "Appending $line to ssh_file\n"
     echo $line >> $1
fi
 
done < $2
