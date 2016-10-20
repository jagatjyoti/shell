#!/bin/sh

#This installs maven2 & a default JDK 
sudo apt-get install maven2;

#Makes the /usr/lib/mvn in case...
sudo mkdir -p /usr/lib/mvn;

#Clean out /tmp...
sudo rm -rf /tmp/*;
cd /tmp;

#Update this line to reflect newer versions of maven
wget http://mirrors.powertech.no/www.apache.org/dist//maven/binaries/apache-maven-3.0.3-bin.tar.gz;
tar -xvf ./*gz;

#Move it to where it to logical location
sudo mv /tmp/apache-maven-3.* /usr/lib/mvn/;

#Link the new Maven to the bin... (update for higher/newer version)...
sudo ln -s /usr/lib/mvn/apache-maven-3.0.3/bin/mvn /usr/bin/mvn;

#test
mvn -version;

exit 0;
