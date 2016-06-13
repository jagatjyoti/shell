#!/bin/bash

run_rpm()
{
  read -p "Enter rpm to be queried and installed if not present: " pkg
  dpkg -l | grep -i $pkg > /dev/null
  retval=$?
  if [ "$retval" -ne 0 ]; then
    echo "Package not found, Installing ..."
    sudo apt-get install $pkg
  else
    echo "Package $pkg is present on the system"
  fi
}

query_user()
{
  read -p "Enter user to be searched: " user
  grep "^$user" /etc/passwd > /dev/null && echo "User $user found" || echo "User $user not found"
}

show_stats()
{
  echo "******************************   SYSTEM STATS   *********************************"
  echo "                                                                                 "
  echo "Uptime: "; uptime
  echo "----------------------------------------------------------------------------------"
  echo "RAM usage"; free -h
  echo "----------------------------------------------------------------------------------"
  echo "Users logged on: "; who
  echo "----------------------------------------------------------------------------------"
  echo "Disk space: "; df -h
  echo "----------------------------------------------------------------------------------"
}

remote_command()
{
  read -p "Enter command to be ran and remote machine's IP separated by space: " command IP
  ping -c 1 $IP
  retval=$?
  if [ "$retval" -ne 0 ]; then
    echo "Found host to be down. Exiting ..."; exit 2;
  else
    echo "Host is up. Running command on remote machine $IP"
    /usr/bin/ssh root@$IP `command`
  fi
}

usage()
{
  echo "Usage: $0 -r -u -s -c"
  echo "  where"
  echo "    -r check and install rpm if not installed"
  echo "    -u query a specific user exists"
  echo "    -s show current system stats"
  echo "    -c run a command in remote machine"
}

# Main program

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

while getopts rusc opt
do
  case "$opt" in
    r) run_rpm;;
    u) query_user;;
    s) show_stats;;
    c) remote_command;;
  esac
done
