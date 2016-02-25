#!/bin/bash

USAGE="Usage: $0 [-fileno|-filename] directory"

case "$1" in 
                 -fileno)  echo "No. of files: $(ls | wc - l)"  ;;
               -filename)  echo "Filenames are:$(ls)"  ;;
                       *)  echo "$USAGE"
              exit 0 
              ;;
esac
