#!/bin/bash

echo " "
echo "############################" >> log
echo "## STAGE 1                ##" >> log
echo "##------------------------##" >> log
echo "## Running Intense scan...##" >> log
echo " "
# Run Intense scan 
nmap -v -A -oA intense $1

echo " "
echo "## Running Vuln scan...##" >> log
echo " "
# Run Vuln scan 
nmap -v -sC -sV --script=*vuln* -oA vuln $1

# If 80 or 8080 is open, run nikto and dirb
if [[ -n $(grep "80/open" intense.gnmap) ]]
then
    echo "## HTTP Found Running Nikto & WFuzz...##" >> log
    nikto h $1
    wfuzz -c -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --hc 404 http://$1/?FUZZ | tee wfuzzscan
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "## HTTP Found Running Nikto & WFuzz...##" >> log
    nikto h $1 | tee niktoscan
    wfuzz -c -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt --hc 404 http://$1/?FUZZ | tee wfuzzscan
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "## SMB Found Running Enum4Linux...##" >> log
    enum4linux -a $1 | tee enum4linuxscan  
fi

echo " "
echo "## Running full TCP scan...##" >> log
echo " "
# Run full TCP scan
nmap -v -p 1-65355 -oA fullTCP $1
