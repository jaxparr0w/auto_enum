
A few tools that I created to assist in pentesting. Nothing fancy, just helps with my workflow. 


  ██▓███   ██▓ ██▀███   ▄▄▄       ███▄    █  ██░ ██  ▄▄▄      
 ▓██░  ██▒▓██▒▓██ ▒ ██▒▒████▄     ██ ▀█   █ ▓██░ ██▒▒████▄    
 ▓██░ ██▓▒▒██▒▓██ ░▄█ ▒▒██  ▀█▄  ▓██  ▀█ ██▒▒██▀▀██░▒██  ▀█▄  
 ▒██▄█▓▒ ▒░██░▒██▀▀█▄  ░██▄▄▄▄██ ▓██▒  ▐▌██▒░▓█ ░██ ░██▄▄▄▄██ 
 ▒██▒ ░  ░░██░░██▓ ▒██▒ ▓█   ▓██▒▒██░   ▓██░░▓█▒░██▓ ▓█   ▓██▒
 ▒▓▒░ ░  ░░▓  ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ▒ ░░▒░▒ ▒▒   ▓▒█░
 ░▒ ░      ▒ ░  ░▒ ░ ▒░  ▒   ▒▒ ░░ ░░   ░ ▒░ ▒ ░▒░ ░  ▒   ▒▒ ░
 ░░        ▒ ░  ░░   ░   ░   ▒      ░   ░ ░  ░  ░░ ░  ░   ▒   
           ░     ░           ░  ░         ░  ░  ░  ░      ░  ░
                                                         
▓█  ▒  ░   Enumerating the target, one byte at a time  ░  ▒ █▓

██  ▒  ░   TARGET : $1 "  

Usage: ./piranha.sh <target IP>

First Stage: Will run an initial nmap scan using intense scan "-A" in all formats. Outputs as intense.*
Second Stage: Greps intense.xml output and runs other enumeration tools based on found open ports, produces reports in plaintext. 
Current tools:\n
  -enum4linux (137,445)
  -crackmapexec (445)
  -gobuster (80, 8080, 443)
  -nikto (80, 8080, 443)
  -onesixtyone (161)
  
#jaxparr0w\n
https://twitter.com/subnetbot
  
