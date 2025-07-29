#!/bin/bash
##----- Author : Syrder Baptichon
##----- Purpose : Basic Server Performance Stats Analyzer
##----- Usage : ./server-stats.sh
##----- Project from roadmap.sh (https://roadmap.sh/projects/server-stats)

# Variables
S=*******************************
CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage}')
MEM_USAGE=$(free | grep "Mem" | awk '{print $3/$2*100}')
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
load_1m=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | xargs)

echo "$S"
echo -e "\tGeneral System Info"
echo "$S"
# Hostname
echo "Hostname: $(hostname)"
# Operating system version
echo "Linux Version: $(grep '^PRETTY_NAME' /etc/os-release | cut -d= -f2 | tr -d '"')"
# Kernel version
echo "Kernel Version: $(uname -r)"
# Architecture
echo -n "OS Architecture: "
[[ $(uname -m) == x86_64 ]] && echo "64 Bit OS" || echo "32 Bit OS"
# System uptime
echo -en "System Uptime : " $(uptime -p)
# Current date
echo -e "\nCurrent System Date & Time : "$(date +%c)
# Nubmer of active users
echo -e "Currently there are$(uptime | awk -F, '{print $3}') logged in. \n"

echo "$S"
echo -e "\tTotal CPU Usage"
echo "$S"
echo -e "${CPU_USAGE} "%" \n"

echo "$S"
echo -e "\tTotal Memory Usage"
echo "$S"
echo "$(free | grep "Mem" | awk '{printf "Total: %.2f GiB\n", $2/1024^2}')"
echo "$(free | grep "Mem" | awk '{printf "Used: %.2f GiB (%.2f%%)\n", $3/1024^2, $3/$2*100}')"
echo -e "$(free | grep "Mem" | awk '{printf "Free: %.2f GiB (%.2f%%)\n", $4/1024^2, $4/$2*100}') \n"

echo "$S"
echo -e "\tTotal Disk Usage"
echo "$S"
echo "$(df -h / | tail -1 | awk '{printf "Total: %s\n", $2}')"
echo "$(df -h / | tail -1 | awk '{printf "Used: %s (%s)\n", $3, $5}')"
echo -e "$(df -h / | tail -1 | awk '{printf "Available: %s\n", $4}') \n"

echo "$S"
echo -e "\tCurrently Mounted File Systems"
echo "$S"
echo -e "$(mount | grep -E '^/dev/' | awk '{print $1 "\t" $3 "\t" $5}' | column -t) \n"

echo "$S"
echo -e "\tDisk Usage On All File Systems "
echo "$S"
echo -e "$(df -h | grep -E '^/dev/' | awk '{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' | column -t) \n"

echo "$S"
echo -e "\tTop 5 Processes MEM"
echo "$S"
echo -e "$(ps aux --sort=-%mem | head -n 6 | awk 'NR==1{print "USER\tPID\tMEM%\tCOMMAND"} NR>1{print $1 "\t" $2 "\t" $4 "\t" $11}') \n"

echo "$S"
echo -e "\tTop 5 Processes CPU"
echo "$S"
echo -e "$(ps aux --sort=-%cpu | head -n 6 | awk 'NR==1{print "USER\tPID\tCPU%\tCOMMAND"} NR>1{print $1 "\t" $2 "\t" $3 "\t" $11}') \n"

echo "$S"
echo -e "\tQuick System Health"
echo "$S"
echo "CPU Usage: ${CPU_USAGE}% $(if (( $(echo "$CPU_USAGE > 80" | bc -l 2>/dev/null || echo "0") )); then echo "[HIGH]"; elif (( $(echo "$CPU_USAGE > 60" | bc -l 2>/dev/null || echo "0") )); then echo "[MODERATE]"; else echo "[NORMAL]"; fi)"
echo "Memory Usage: $(printf "%.1f" $MEM_USAGE)% $(if (( $(echo "$MEM_USAGE > 90" | bc -l 2>/dev/null || echo "0") )); then echo "[CRITICAL]"; elif (( $(echo "$MEM_USAGE > 80" | bc -l 2>/dev/null || echo "0") )); then echo "[HIGH]"; else echo "[NORMAL]"; fi)"
echo "Disk Usage: ${DISK_USAGE}% $(if [ $DISK_USAGE -gt 90 ]; then echo "[CRITICAL]"; elif [ $DISK_USAGE -gt 80 ]; then echo "[HIGH]"; else echo "[NORMAL]"; fi)"
echo -e "Load Average (1m): $load_1m\n"

echo "Report generated on: $(date)"
