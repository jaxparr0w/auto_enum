#!/bin/bash

echo " "
echo "{-- Running Intense scan... --}" >> log
echo " "
# Run Intense scan 
nmap -v -A -oA intense $1

echo " "
echo "[-- Running Vuln scan... --}" >> log
echo " "
# Run Vuln scan 
nmap -v -sC -sV --script=*vuln* -oA vuln $1

echo " "
echo "{-- Running Searchsploit... --}" >> log
echo " "
# Check sploitsearch
searchsploit --nmap intense.xml | tee sploitlist

# if 139 open, run enum4linux
if [[ -n $(grep "139/open" intense.gnmap) ]]
then
    echo "{-- SMB Found Running Enum4Linux... --}" >> log
    enum4linux -a $1 | tee enum4linuxscan  
fi
if [[ -n $(grep "445/open" intense.gnmap) ]]
then
    echo "{-- SMB Found Running Enum4Linux... --}" >> log
    enum4linux -a $1 | tee enum4linuxscan  
fi

# If 80 or 8080 is open, run nikto and dirb
if [[ -n $(grep "80/open" intense.gnmap) ]]
then
    echo "{-- HTTP Found Running Nikto & GoBuster... --}" >> log
    nikto -h $1 | tee niktoscan
    gobuster -w /usr/share/wordlist/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "{-- HTTP Found Running Nikto & GoBuster... --}" >> log
    nikto -h $1:8080 | tee niktoscan
    gobuster -w /usr/share/wordlist/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://$1:8080 -o gobustlist.txt
fi
if [[ -n $(grep "443/open" intense.gnmap) ]]
then
    echo "{-- HTTPS Found Running Nikto & Gobuster... --}" >> log
    nikto -h -ssl $1 | tee niktoscan
    gobuster -w /usr/share/wordlist/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k
fi

echo " "
echo "{-- Running full TCP scan... --}" >> log
echo " "
# Run full TCP scan
nmap -v -p 1-65355 -T4 -oA fullTCP $1
