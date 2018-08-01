#!/bin/bash

# Run Intense scan
nmap -v -A -oA intense $1

# Run Vuln scan
nmap -v -sC -sV --script=*vuln* -oA vuln $1

# Run full TCP scan
nmap -v -p 1-65355 -oA fullTCP $1

# If 80 open, run nikto and dirb
if [[ -n $(grep "80/open" intense.gnmap) ]]
then
    echo "HTTP Found Running Nikto"
    nikto h $1
fi
if [[ -n $(grep "8080/open" intense.gnmap) ]]
then
    echo "HTTP Found Running Nikto"
    nikto h $1
fi
