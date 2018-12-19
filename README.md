
PIRANHA.sh 

A few tools that I created to assist in pentesting. Nothing fancy, just helps with my workflow. 

![My image](jaxparr0w.github.com/auto_enum/piranha.png)                     

Usage: `./piranha.sh <target IP>`

First Stage: Will run an initial nmap scan using intense scan "-A" in all formats. Outputs as intense.(nmap,gmap,xml)

Second Stage: Greps intense.xml output and runs other enumeration tools based on found open ports, produces reports in plaintext. 

| Tool | Port Trigger | Output Report |
|------------| ------------| -----------|
| enum4linux | 137,445 | enum4linuxscan |
| crackmapexec | 445 | crackmapexec_smb | 
| gobuster | 80, 8080, 443 | gobustlist.txt |
| nikto | 80, 8080, 443 | niktoscan |
| snmpwalk | 161 | snmpenum | 

Produces a log 
  
#jaxparr0w
https://twitter.com/subnetbot
  
