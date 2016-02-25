#!/bin/bash
echo "script to display network info"
echo "Current Date: $(date) @ $(hostname)"
echo "Network info"
/sbin/ifconfig
