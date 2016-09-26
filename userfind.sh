#!/bin/bash

args=$#
[ $args -eq 0 ] && echo "Usage: $0 username1 username2 ..." || echo "Script to find users in /etc/passwd file"
echo "Proceeding with "$#" arguments given by user"
for i in "$@"
do
    getent passwd $i > /dev/null
    if  [ "$?" -eq 0 ]
        then
        echo "User $i found"
    else
       echo  "User $i doesn't exist"
    fi
done
