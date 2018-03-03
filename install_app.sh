#!/bin/bash


# Check root user
if [ $(id -u) != 0 ]; then
  echo "ERROR: Script can only be run by root! Aborting ..."; exit 1;
fi

# Usage
if [ $# != 2 ]; then
  echo -e "Usage: $0 mount_location mount_command_from_azure_portal \nIMPORTANT: Provide double quotes for mount_command_from_azure_portal !!!"
  exit 1
fi

{

# Logging
echo -e "INFO: Logfile location - /var/log/preinstall.log \n"

status=$?

mnt_point=$1
mnt_command=$2

# Validate salt setup
function check_salt_setup()

{
  echo "INFO: Checking salt setup ... "
  machine=`ls /etc/salt | egrep "master|minion_id"`
  if [ "$machine" == "master" ]; then
    echo "INFO: This node appears to be Master node"
    echo "INFO: Below minions configured: "
    /bin/salt-key -L
    if [ "$status" -eq 1 ]; then
          echo "ERROR: Salt is not installed or Master node is not properly configured, exiting !"; exit 1;
    else
          echo -e "INFO: Salt master setup looks good ! \n"
    fi
    minion_count=`/bin/salt-key -L | grep wmic | wc -l`
    if [ "$minion_count" -eq 0 ]; then
        echo "ERROR: No Minions detected, exiting !"; exit 1;
    fi
  elif [ "$machine" == "minion_id" ]; then
    echo "INFO: This node appears to be a Minion"
    min_id=`cat /etc/salt/minion_id`
    echo -e "INFO: Minion ID: " $min_id && echo -e "INFO: Minion setup looks good here ! \n"
  else
      echo "ERROR: No salt component found. Considering this node as minion and beginning minion installation ... "
      yum install -y epel-release
      yum install -y salt-minion && echo "Salt minion installed successfully"
  fi
}

# Install java if not
function java_exists()

{
  echo "INFO: Checking whether Java is installed on all minions ..."
  java_version=`java -version 2>&1 >/dev/null | grep 'java version' | awk '{print $3}'`
  if [[ -z "$java_version" ]]; then
    echo "WARNING: Java is not installed or PATH not set. Beginning to install JAVA ..."
    cd /opt/
    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.tar.gz"
    echo "INFO: Extracting java"
    tar xzf jdk-8u161-linux-x64.tar.gz
    cd /opt/jdk1.8.0_161/
    alternatives --install /usr/bin/java java /opt/jdk1.8.0_161/bin/java 2
    echo "INPUT: Press Enter:"
    alternatives --config java
    echo "java version"
    java -version && echo "Java installed successfully !"
    cd ~
  else
    echo "INFO: Java version: " $java_version
  fi
}

# Copy the tar from Azure portal and extract it
function copy_extract_tar()

{
  echo "INFO: Mount point provided: " $mnt_point
  echo "INFO: Mount command from Azure portal: " $mnt_command
  echo "INFO: Creating provided mount point ..."
  mkdir -p $mnt_point
  execute_mount=`echo $mnt_command | sed -e "s@\[mount point]@$mnt_point@g"`
  echo $execute_mount
  echo -e "\n \n"
  $execute_mount && echo "INFO: Mount successful !"
  echo "INFO: Checking for available file share ..."
  df -h | grep -i windows || { echo "ERROR: No Mount point found for Azure. Exiting ..."; exit 1; }
  tar_count=`ls $mnt_point | egrep "*.tar.gz|*.zip|*.tar" | wc -l`
  if [ "$tar_count" -gt 1 ]; then
    echo "ERROR: Multiple tar files found. Should be at max 1 i.e. LIP tar. Aborting ..."; exit 1;
  fi
  tar_filename=`ls $mnt_point | grep -i lip`
  echo "INFO: Deleting previous /opt/install directory" && rm -rf /opt/install
  echo "INFO: Creating folder /opt/install and copying tar ..." && mkdir -p /opt/install
  cp -v $mnt_point/$tar_filename /opt/install
  if [ "$status" -eq 1 ]; then
    echo "ERROR: Copy failed ..."; exit 1;
  fi
  tar -xvf /opt/install/$tar_filename -C /opt/install && echo "INFO: Untarring successful !"
  if [ "$status" -eq 1 ]; then
    echo "INFO: Untarring failed ..."; exit 1;
  fi
}


# Main ()
check_salt_setup
java_exists
copy_extract_tar
} | tee /var/log/preinstall.log
