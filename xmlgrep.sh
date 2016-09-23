#!/bin/bash

#Ensure xml_grep package is already installed on your system. emp.xml is the xml file here.

if [ $# -ne 1 ];then
  echo "Usage: $0 XML_file. Please provide a valid XML file. Aborting ...";
  exit 1;
fi

XML_file=$1
echo "****************** EMPLOYEE DETAILS ***********************"
echo ""
echo "Name of employee: " $(xml_grep 'Name' $XML_file --text_only)
echo "Date of Birth: " $(xml_grep 'DateOfBirth' $XML_file --text_only)
echo "Employee Type: " $(xml_grep 'EmployeeType' $XML_file --text_only)
echo "Salary: " $(xml_grep 'Salary' $XML_file --text_only)
echo ""
echo "************************* END *******************************"
