#!/bin/bash

LOG_FILE="/var/log/health_check.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
TOP_PROCESSES=$(ps aux --sort=-%mem | awk 'NR<=5 {print $0}')
totalMemoryUsed=$(free | awk '/Mem:/ { printf "%.0f\n", ($3/$2)*100 }')
totalCPUUtillised=$(top -b -n1 | grep "Cpu(s)" | awk '{usage=100-$8; printf "%.0f", usage}')
totalUsedSpace=$(df -h --total | grep total | awk '{print $5}'| tr -d '%')
totalProcessesRunning=$(ps -e --no-headers | wc -l)
UPTIME=$(uptime -p)

echo "---------- Health Check Report: $DATE ----------"
echo "CPU Usage: $totalCPUUtillised%"
echo "Memory Usage: Total=${MEM_TOTAL}MB, Used=${MEM_USED}MB, $totalMemoryUsed%, Free=${MEM_FREE}MB"
echo "Disk Usage: $totalUsedSpace%"
echo "Top 5 Memory-Consuming Processes:"
echo "$TOP_PROCESSES"
echo "System Uptime: $UPTIME"
echo "-------------------------------------------------"

echo "---------- Health Check Report: $DATE ----------" >> $LOG_FILE
echo "CPU Usage: $totalCPUUtillised%" >> $LOG_FILE
echo "Memory Usage: Total=${MEM_TOTAL}MB, Used=${MEM_USED}MB,totalMemoryUsed%, Free=${MEM_FREE}MB" >> $LOG_FILE
echo "Disk Usage: $DISK_USAGE" >> $LOG_FILE
echo "Top 5 Memory-Consuming Processes:" >> $LOG_FILE
echo "$TOP_PROCESSES" >> $LOG_FILE
echo "System Uptime: $UPTIME" >> $LOG_FILE
echo "-------------------------------------------------" >> $LOG_FILE

if [ $totalMemoryUsed -gt 80 ]; then
        echo "Alert! total memory used is $totalMemoryUsed"
fi
if [ $totalCPUUtillised -gt 80 ]; then
        echo "Alert! total memory used is $totalCPUUtillised"
fi
if [ $totalUsedSpace -gt 80 ]; then
        echo "Alert! total storage space used is $totalUsedSpace"
fi
if [ $totalProcessesRunning -gt 200 ]; then
        echo "Alert! total processes running are $totalProcessesRunning"
fi
