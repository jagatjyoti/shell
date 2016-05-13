#!/bin/sh
 
SYSTYPE=`uname`
PATH="/usr/bin:${PATH}"
rpmDir=${1}
 
if [ ! -d "$rpmDir" ]
then
     echo "- ERROR - $rpmDir does not exists"
     exit 1
fi
 
#check if the package installed
for file in $rpmDir/*.rpm
do
     echo $file
     file $file | grep -i RPM
     if [ $? -ne 0 ]
     then
           continue
     fi
     rpmName=`rpm -q --queryformat '%{NAME}\n' -p $file`
     rpmVer=`rpm -q --queryformat '%{VERSION}\n' -p $file`
     echo " NAME: $rpmName VER: $rpmVer"
    
     rpm -q $rpmName
     if [ $? -eq 0 ]
     then
           oldVerRpm=`rpm -q --queryformat '%{VERSION}\n' $rpmName`
           echo "Older VER: $oldVerRpm"
                oldVerRpm_short=`echo $oldVerRpm | cut -d . -f 4`
                rpmVer_short=`echo $rpmVer | cut -d . -f 4`
           verchk=`echo "$oldVerRpm_short" "$rpmVer_short"|awk '{if [[ $1 >= $2 ]] print 0 ; else print 1 }'`
 
           if [ $verchk != 0 ]
           then
#               echo "Removing older version of $rpmName"
                echo "Updating older version of $rpmName"
                rpm -Uvh --nodeps $file
                if [ $? -ne 0 ]
                     then
                     echo "-ERROR - Failed to upgrade older version of $rpmName "
                     exit 1
                fi
           else
                echo "$rpmName is already installed on the system with the same or higher version ($oldVerRpm), Skipping..."
                continue
           fi
     else
           echo "Installing $rpmName..."
           rpm -ivh --nodeps $file
           if [ $? -ne 0 ]
           then
                echo "-ERROR - Failed to install $rpmName "
                exit 1
           fi
     fi
done
 
exit 0
