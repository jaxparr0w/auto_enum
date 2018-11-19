#!/bin/bash
# Piranha  :: Initial Enumeration Script
# Author: jaxparr0w 
# v2 :: 11/19/2018
# Dependencies: nmap, nikto, enum4linux, gobuster, onesixtyone

echo " "
echo "[ ] Running Intense scan" >> log
echo " "
# Run Intense scan 
nmap -v -A -sU -oA intense $1
zenity --info --text="$1 Intense Scan Complete"

echo " "
echo "[ ] Running Vuln scan" >> log
echo " "
# Run Vuln scan 
nmap -v -sC -sV --script=*vuln* -oA vuln $1
zenity --info --text="$1 Nmap vuln Scan Complete"

echo " "
echo "[ ] Running Searchsploit" >> log
echo " "
# Check sploitsearch
searchsploit --nmap intense.xml | tee sploitlist
zenity --info --text="$1 Searchsploit Complete"

# if 139 open, run enum4linux
if [[ -n $(grep "139/open" intense.gnmap) ]]
then
    echo "[ ] NetBios Found Running Enum4Linux" >> log
    enum4linux -a $1 | tee enum4linuxscan 
    zenity --info --text="$1 Enum4Linix Complete"
fi
if [[ -n $(grep "445/open" intense.gnmap) ]]
then
    echo "[ ] SMB Found Running Enum4Linux" >> log
    enum4linux -a $1 | tee enum4linuxscan 
    zenity --info --text="$1 Enum4Linix Complete"
fi

# If 80 or 8080 is open, run nikto and gobuster
if [[ -n $(grep "80/open" intense.gnmap) ]]
then
    echo "[ ] HTTP Found Running Nikto & GoBuster" >> log
    nikto -h $1 | tee niktoscan
    zenity --info --text="$1 Nikto Scan Complete"
    gobuster -w gobuster -w /usr/share/wordlist/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k -u http://$1 -o gobustlist.txt
    zenity --info --text="$1 GoBuster Complete"
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "[ ] HTTP Found Running Nikto & GoBuster" >> log
    nikto -h $1:8080 | tee niktoscan
    zenity --info --text="$1 Nikto Scan Complete"
    gobuster -w gobuster -w /usr/share/wordlist/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k-u http://$1:8080 -o gobustlist.txt
    zenity --info --text="$1 GoBuster Complete"
fi
if [[ -n $(grep "443/open" intense.gnmap) ]]
then
    echo "[ ] HTTPS Found Running Nikto & Gobuster" >> log
    nikto -h -ssl $1 | tee niktoscan
    zenity --info --text="$1 Nikto Scan Complete"
    gobuster -w gobuster -w /usr/share/wordlist/dirbuster/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k -u http://$1 -o gobustlist.txt -k
    zenity --info --text="$1 GoBuster Complete"
fi
if [[ -n $(grep "161/open" intense.gnmap) ]]
then
    echo "{-- SNMP Found, Runing OneSixtyOne... --}" >> log
    onesixtyone $1 -o snmpscan
    zenity --info --text="$1 OneSixtyOne Complete"
fi

echo " "
echo "{-- Running full TCP scan... --}" >> log
echo " "
# Run full TCP scan
nmap -v -p 1-65355 -T4 -oA fullTCP $1
zenity --info --text="$1 Full TCP Scan Complete"
