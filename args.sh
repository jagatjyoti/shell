#!/bin/bash

 

usage() {echo "Usage: $0 --user --ip"; exit 1; }

while getopts :u:ip:h args; do

  case $args in

                u)

                       user=$OPTARG

                       echo "User is: " user;;

                ip)

                      ip=$OPTARG

                      echo "IP is: " ip;;

                h)

                     usage();;

   esac

done
