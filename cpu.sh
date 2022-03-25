#!/bin/bash
cpuuse=$(cat /proc/loadavg | awk '{print $3}'|cut -f 1 -d ".")
if [ "$cpuuse" -ge 0 ]; then
  SUBJECT="ATTENTION: CPU load is high on $(hostname) at $(date)"
  MESSAGE="/tmp/Mail.out"
  TO="olanreaz@ucmail.uc.edu,hortongn@ucmail.uc.edu"
  echo "CPU current usage is: $cpuuse%" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "--------------------------------------------------------------------" >> $MESSAGE
  echo "Top 20 processes which consuming high CPU" >> $MESSAGE
  echo "--------------------------------------------------------------------" >> $MESSAGE
  echo "$(top -bn1 | head -20)" >> $MESSAGE
  echo "" >> $MESSAGE
  echo "--------------------------------------------------------------------" >> $MESSAGE
  echo "Top 10 Processes which consuming high CPU using the ps command" >> $MESSAGE
  echo "--------------------------------------------------------------------" >> $MESSAGE
  echo "$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10)" >> $MESSAGE
  mail -s "$SUBJECT" "$TO" < $MESSAGE
  rm /tmp/Mail.out
else
   echo "Server CPU usage is in under threshold"
fi
