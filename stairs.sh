#!/bin/bash

# This script accepts number of stairs and then calculates how many jumps would it take to reach 
# the last stair in a fashion of 0, 1, 2, 3 ...
 
read -p "Enter number of stairs: " stairs 

initial_pos=0
after_pos=0
count=0
while [ $after_pos -lt $stairs ]; do
        after_pos=$(( $initial_pos + $count ))
        initial_pos=$after_pos
        count=$(( $count + 1 ))
done
 
echo "Number of jumps needed to climb $stairs stairs: " $(( $count - 1 ))
