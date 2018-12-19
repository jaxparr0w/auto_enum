
A tool to perform initial enumeration of a system to assist in pentesting. Nothing fancy, just helps with my workflow. 
All reports are in plaintext for import into cherry tree or used for grep, etc. 

![My image](jaxparr0w.github.com/auto_enum/piranha.png)                     

Usage: ./piranha.sh <target IP>

First Stage: Will run an initial nmap scan using intense scan "-A" in all formats. Outputs as intense.(nmap,gmap,xml)

Second Stage: Greps intense.xml output and runs other enumeration tools based on found open ports, produces reports in plaintext. 

| Tool | Port Trigger | Output Report |
|------------| ------------| -----------|
| enum4linux | 137,445 | enum4linuxscan |
| crackmapexec | 445 | crackmapexec_smb | 
| gobuster | 80, 8080, 443 | gobustlist.txt |
| nikto | 80, 8080, 443 | niktoscan |
| snmpwalk | 161 | snmpenum | 
  
Last Stage: A full TCP scan with nmap. 

A log is generated (plog) showing status of each tool that is run. I usually kick the tool off and grep the plog from time to time while it is running. 

#jaxparr0w
https://twitter.com/subnetbot
  
