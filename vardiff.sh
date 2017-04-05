#!/bin/bash
 
tmp()
{
  var="root daemon bin sys sync games man lp mail news uucp proxy www-data backup list irc gnats nobody systemd-timesync systemd-network systemd-resolve systemd-bus-proxy syslog _apt lxd messagebus uuidd dnsmasq sshd zarvis"
  foo="games backup nobody zarvis"
  varray={$var}
  for v in ${varray[@]}
  do
    if ! [[ "$foo" =~ "$v" ]]; then
       echo "$v"
    fi
  done
}
 
tmp
