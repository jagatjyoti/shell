#!/bin/bash

read -p "Enter file to be searched: " $file
read -p "Enter the word you want to search for: " $word

count=$(grep -o "^${word}:" $file | wc -l)
echo "The count for `$word`: " $count
