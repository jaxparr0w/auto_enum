
PIRANHA.sh 

A tool that performs intial enumeration of a target to assist in pentesting. Nothing fancy, just helps with my workflow. 
Requires tools listed below installed, all tools default on Rolling Kali Linux. 

![My image](https://github.com/jaxparr0w/auto_enum/blob/master/piranha.JPG)                     

Usage: `./piranha.sh <target IP>`

First Stage: Will run an initial nmap scan using intense scan "-A" in all formats (Enable OS detection, version detection, script scanning, and traceroute). Outputs as intense.(nmap,gmap,xml)

Second Stage: Greps intense.xml output and runs other enumeration tools based on found open ports, produces reports in plaintext. 

Current Tools incorporated and port that triggers the tool. Reports are automatically generated, tools run on screen as well ::

| Tool | Port Trigger | Output Report |
|------------| ------------| -----------|
| enum4linux | 137,445 | enum4linuxscan |
| SMBMap | 445 | smbmap_* | 
| gobuster | 80, 8080, 443 | gobustlist.txt |
| nikto | 80, 8080, 443 | niktoscan |
| snmpwalk | 161 | snmpenum | 

Produces a log `plog` that shows status of each tool being run. Currently a serial process, iterates through each tool one at a time, plan to multithread in the future. 
  
#jaxparr0w
https://twitter.com/subnetbot
  
