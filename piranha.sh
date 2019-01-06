#!/bin/bash
# Piranha :: Initial Enumeration Script
# Author :: jaxparr0w 
# v2 :: 12/19/2018
# Dependencies: nmap, nikto, enum4linux, gobuster, crackmapexec, snmpwalk
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
echo "▓█ Running Intense scan..." >> plog
echo " "
# Run Intense scan 
nmap -v -A -oA intense $1
echo "▓█ [x] Intense scan complete" >> plog

echo " "
echo "▓█ Running Vuln scan..." >> plog
echo " "
# Run Vuln scan 
nmap -v -sC -sV --script=*vuln* -oA vuln $1
echo "▓█ [x] Vuln scan complete" >> plog

echo " "
echo "▓█ Running Searchsploit..." >> plog
echo " "
# Check sploitsearch
searchsploit --nmap intense.xml | tee sploitlist
echo "▓█ [x] Searchsploit Complete" >> plog

# if 139 open, run enum4linux
if [[ -n $(grep "139/open" intense.gnmap) ]]
then
    echo "▓█ NetBios Found Running Enum4Linux..." >> plog
    enum4linux -a $1 | tee enum4linuxscan 
    echo "▓█ [x] Enum4Linux complete" >> plog
fi
if [[ -n $(grep "445/open" intense.gnmap) ]]
then
    echo "▓█ SMB Found Running Enum4Linux..." >> plog
    enum4linux -a $1 | tee enum4linuxscan 
    echo "▓█ [x] Enum4Linux complete" >> plog
    echo "▓█ SMB Found Running CrackMapExec..." >> plog
    smbmap -H $1 -L | tee smbmap_shares
    smbmap -H $1 -R | tee smbmap_rcrsv
    echo "▓█ [x] SMBMAP Complete" >> plog
fi

# If 80 or 8080 is open, run nikto and gobuster
if [[ -n $(grep "80/open" intense.gnmap) ]]
then
    echo "▓█ Curl site and robots..." >> plog
    curl -v http://$1 >> sitecurl
    curl -v http://$1/robots.txt >> robots.txt
    echo "▓█ [x] Curl complete" >> plog
    echo "▓█ HTTP Found Running Nikto & GoBuster..." >> plog
    nikto -h $1 | tee niktoscan
    gobuster -w gobuster -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist.txt 
    echo "▓█ [x] GoBuster complete" >> plog
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "▓█ Curl site and robots..." >> plog
    curl -v http://$1:8080 >> sitecurl
    curl -v http://$1:8080/robots.txt >> 8080robots.txt
    echo "▓█ [x] Curl complete" >> plog
    echo "▓█ HTTP Found Running Nikto & GoBuster..." >> plog
    nikto -h $1:8080 | tee niktoscan
    gobuster -w gobuster -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt -u http://$1 -o gobustlist_8080.txt 
    echo "▓█ [x] GoBuster complete" >> plog
fi
if [[ -n $(grep "443/open" intense.gnmap) ]]
then
    echo "▓█ Curl site and robots..." >> plog
    curl -v -k https://$1 >> 443sitecurl
    curl -v -k https://$1/robots.txt >> 443robots.txt
    echo "▓█ [x] Curl complete" >> plog
    echo "▓█ HTTPS Found Running Nikto & Gobuster..." >> plog
    nikto -h -ssl $1 | tee niktoscan
    gobuster -w gobuster -w /usr/share/dirbuster/wordlists/directory-list-lowercase-2.3-medium.txt -u https://$1 -o gobustlist_443.txt -k 
    echo "▓█ [x] GoBuster complete" >> plog
fi
if [[ -n $(grep "161/open" intense.gnmap) ]]
then
    echo "▓█ SNMP Found, Runing Snmpwalk on Windows MIBs..." >> log
    snmpwalk -c public -v1 $1 1.3.6.1.4.1.77.1.2.25 >> snmpenum
    snmpwalk -c public -v1 $1 1.3.6.1.2.1.25.4.2.1.2 >> snmpenum
    snmpwalk -c public -v1 $1 1.3.6.1.2.1.6.13.1.3 >> snmpenum
    echo "▓█ [x] SNMPWalk complete" >> plog
fi

#TODO :: Add FTP Brute force
#if [[ -n $(grep "21/open" intense.gnmap) ]]
#then    
#    variable=$(zenity --entry --text="FTP found. Do you want to brute force (yes or no)?")
#        if [ $variable == "yes" ]
#        then
#            #do some ftp brute here
#        else
#        fi
#fi
echo " "
echo "▓█ Running full TCP scan..." >> plog
echo " "
# Run full TCP scan
nmap -v -p 1-65355 -T4 -sT -oA fullTCP $1
zenity --info --text="$1 Full TCP Scan Complete"
echo "▓█ [x] Full TCP scan complete" >> plog
echo " "
echo "▓█ Running Intense UDP scan..." >> plog
echo " "
# Run Intense scan 
nmap -v -A -sU -p 1-65535 -oA fullUDP $1
echo "▓█ [x] Intense UDP scan complete" >> plog
