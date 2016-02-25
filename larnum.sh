#!/bin/bash

n1=$1;n2=$2;n3=$3;n4=$4;n5=$5

if [ $# -lt 5 ] 
then
echo "Insufficient arguments. Exiting!"; exit 1; 
fi

  if [ $n1 -gt $n2 ] && [ $n1 -gt $n3 ] && [ $n1 -gt $n4 ] && [ $n1 -gt $n5 ]
    then
         echo "$n1 is greater number" 

  elif [ $n2 -gt $n1 ] && [ $n2 -gt $n3 ] && [ $n2 -gt $n4 ] && [ $n2 -gt $n5 ]  
    then
         echo "$n2 is greater number" 

  elif [ $n3 -gt $n1 ] && [ $n3 -gt $n2 ] && [ $n3 -gt $n4 ] && [ $n3 -gt $n5 ]
    then 
          echo "$n3 is greater number"

  elif [ $n4 -gt $n1 ] && [ $n4 -gt $n2 ] && [ $n4 -gt $n3 ] && [ $n4 -gt $n5 ]
   then
          echo "$n4 is greater number"

else 

         echo "$n5 is the greater number"

fi
