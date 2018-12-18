#!/bin/bash
# Piranha  :: Initial Enumeration Script
# Author: jaxparr0w 
# v2 :: 11/23/2018
# Dependencies: nmap, nikto, enum4linux, gobuster, onesixtyone, crackmapexec
# Basically an updted rolling Kali image

echo "                                                              "
echo "  ██▓███   ██▓ ██▀███   ▄▄▄       ███▄    █  ██░ ██  ▄▄▄      "
echo " ▓██░  ██▒▓██▒▓██ ▒ ██▒▒████▄     ██ ▀█   █ ▓██░ ██▒▒████▄    "
echo " ▓██░ ██▓▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄  ▓██  ▀█ ██▒▒██▀▀██░▒██  ▀█▄  "
echo " ▒██▄█▓▒ ▒░██░▒██▀▀█▄  ░██▄▄▄▄██ ▓██▒  ▐▌██▒░▓█ ░██ ░██▄▄▄▄██ "
echo " ▒██▒ ░  ░░██░░██▓ ▒██▒ ▓█   ▓██▒▒██░   ▓██░░▓█▒░██▓ ▓█   ▓██▒"
echo " ▒▓▒░ ░  ░░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ▒ ░░▒░▒ ▒▒   ▓▒█░"
echo " ░▒ ░      ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░░ ░░   ░ ▒░ ▒ ░▒░ ░  ▒   ▒▒ ░"
echo " ░░        ▒ ░  ░░   ░   ░   ▒      ░   ░ ░  ░  ░░ ░  ░   ▒   "
echo "           ░     ░           ░  ░         ░  ░  ░  ░      ░  ░"
                                                         
echo "▓█  ▒  ░   Enumerating the target, one byte at a time  ░  ▒ █▓"
echo "██  ▒  ░   TARGET : $1 "                   

echo " "
echo "▓█ Running Intense scan" >> log
echo " "
# Run Intense scan 
nmap -v -A -sU -sT -oA intense $1
echo "▓█ Intense scan complete" >> log

echo " "
echo "▓█ Running Vuln scan" >> log
echo " "
# Run Vuln scan 
nmap -v -sC -sV --script=*vuln* -oA vuln $1
echo "▓█ Vuln scan complete" >> log

echo " "
echo "▓█ Running Searchsploit" >> log
echo " "
# Check sploitsearch
searchsploit --nmap intense.xml | tee sploitlist
echo "▓█ Searchsploit Complete" >> log

# if 139 open, run enum4linux
if [[ -n $(grep "139/open" intense.gnmap) ]]
then
    echo "▓█ NetBios Found Running Enum4Linux" >> log
    enum4linux -a $1 | tee enum4linuxscan 
    echo "▓█ Enum4Linux complete" >> lo
fi
if [[ -n $(grep "445/open" intense.gnmap) ]]
then
    echo "▓█ SMB Found Running Enum4Linux" >> log
    enum4linux -a $1 | tee enum4linuxscan 
    zenity --info --text="$1 Enum4Linix Complete"
    echo "▓█ Enum4Linux complete" >> log
    echo "▓█ SMB Found Running CrackMapExec" >> log
    crackmapexec smb $1 -u '' -p '' >> crackmapexec_smb
    echo "▓█ CrackmapExec SMB Complete" >> log
fi

# If 80 or 8080 is open, run nikto and gobuster
if [[ -n $(grep "80/open" intense.gnmap) ]]
then
    echo "▓█ HTTP Found Running Nikto & GoBuster" >> log
    nikto -h $1 | tee niktoscan
    gobuster -w gobuster -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k -u http://$1 -o gobustlist.txt
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "▓█ HTTP Found Running Nikto & GoBuster" >> log
    nikto -h $1:8080 | tee niktoscan
    gobuster -w gobuster -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k-u http://$1:8080 -o gobustlist.txt
fi
if [[ -n $(grep "443/open" intense.gnmap) ]]
then
    echo "▓█ HTTPS Found Running Nikto & Gobuster" >> log
    nikto -h -ssl $1 | tee niktoscan
    gobuster -w gobuster -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt -k -u http://$1 -o gobustlist.txt -k
fi
if [[ -n $(grep "161/open" intense.gnmap) ]]
then
    echo "▓█ SNMP Found, Runing Snmpwalk on Windows MIBs" >> log
    snmpwalk -c public -v1 $1 1.3.6.1.4.1.77.1.2.25 >> snmpenum
    snmpwalk -c public -v1 $1 1.3.6.1.2.1.25.4.2.1.2 >> snmpenum
    snmpwalk -c public -v1 $1 1.3.6.1.2.1.6.13.1.3 >> snmpenum
fi
if [[ -n $(grep "21/open" intense.gnmap) ]]
then    
    variable=$(zenity --entry --text="FTP found. Do you want to brute force (yes or no)?")
        if [ $variable == "yes" ]
        then
            #do some ftp brute here
        else
            
        fi
fi
echo " "
echo "▓█ Running full TCP scan" >> log
echo " "
# Run full TCP scan
nmap -v -p 1-65355 -T4 -oA fullTCP $1
zenity --info --text="$1 Full TCP Scan Complete"
echo "▓█ Full TCP scan complete" >> log
