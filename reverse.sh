#!/bin/bash

read -p "Enter a number: " num
rev=0
sd=0

while [ $num -gt 0 ]; do
  sd=$(( $num % 10 ))
  rev=$(( $rev * 10 + $sd ))
  num=$(( $num / 10 ))
done

echo "Reverse of the number is: " $rev
