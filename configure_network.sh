#!/bin/bash

#This script does the network configuration for VMware ESXi 

function configure_network_in_esxi()
{
  echo "NOTE: All values are mandatory"
  read -p "Please enter IP address: " ip
  read -p "Please enter DNS: " dns
  read -p "Please enter Netmask: " netmask
  read -p "Please enter Gateway: " gateway

  if [[ -z "$ip" || -z "$dns" || -z "$netmask" || -z "$gateway"  ]]; then
    echo "ERROR: One/many mandatory input(s) not entered. Aborting ..."; exit 1;
  fi
  cat /dev/null > /etc/sysconfig/network-scripts/ifcfg-ens160
  cat > /etc/sysconfig/network-scripts/ifcfg-ens160 << EOF
DEVICE=ens160
BOOTPROTO=none
ONBOOT=yes
NETMASK=
IPADDR=
USERCTL=no
GATEWAY=
DNS1=
EOF

  sed -i -re "s/^(IPADDR)=(.*)/\1=$ip/" /etc/sysconfig/network-scripts/ifcfg-ens160 && \
  sed -i -re "s/^(DNS1)=(.*)/\1=$dns/" /etc/sysconfig/network-scripts/ifcfg-ens160 && \
  sed -i -re "s/^(NETMASK)=(.*)/\1=$netmask/" /etc/sysconfig/network-scripts/ifcfg-ens160 && \
  sed -i -re "s/^(GATEWAY)=(.*)/\1=$gateway/" /etc/sysconfig/network-scripts/ifcfg-ens160 && \
  echo "INFO: Custom values by user inserted" || { echo "ERROR: Failed to insert custom values by user. Exiting ..."; exit 1; }
  sudo systemctl restart network
  retval=$?
  if [[ $retval == 0 ]]; then
    echo "INFO: Network restarted successfully"
  else
    echo "WARNING: Network restarted but with warnings. Continuing ..."
  fi
  ip_val=$(ifconfig | grep -A1 ens160 | sed -n "2p" | awk '{print $2}')
  if [[ $ip_val == $ip ]]; then
    echo "INFO: Static IP configured"
  else
    echo "ERROR: Configuration of static IP Failed. Exiting ..."; exit 1;
  fi
  sed -i -r '3s/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/$ip/ /etc/hosts && \
  echo "INFO: Updating /etc/hosts file with new values" || { echo "ERROR: Failed to update /etc/hosts file. Exiting ..."; exit 1; }
  sudo systemctl restart network
  ping -c1 management.cumulocity.com > /dev/null
  retval=$?
  if [[ $retval == 0 ]]; then
    echo "INFO: Network configuration completed successfully"
  else
    echo "ERROR: Unable to resolve hostname through IP. Something's not right, please check /etc/hosts file"
  fi
}

configure_network_in_esxi
