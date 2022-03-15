#!/bin/sh
ramusage=$(free | awk '/Mem/{printf("RAM Usage: %.2f\n"), $3/$2*100}'| awk '{print $3}')

if [ "$ramusage" > 20 ]; then

 SUBJECT="Memory Utilization is High on $(hostname) at $(date)"
 MESSAGE="/tmp/Mail.out"
 TO="olanreaz@ucmail.uc.edu, hortongn@ucmail.uc.edu"
 echo "Memory Current Usage is: $ramusage%" >> $MESSAGE
 echo "" >> $MESSAGE
 echo "------------------------------------------------------------------" >> $MESSAGE
 echo "Top Memory Consuming Process Using top command" >> $MESSAGE
 echo "------------------------------------------------------------------" >> $MESSAGE
 echo "$(top -b -o +%MEM | head -n 20)" >> $MESSAGE
 echo "" >> $MESSAGE
 echo "------------------------------------------------------------------" >> $MESSAGE
 echo "Top Memory Consuming Process Using ps command" >> $MESSAGE
 echo "------------------------------------------------------------------" >> $MESSAGE
 echo "$(ps -eo pid,ppid,%mem,%Memory,cmd --sort=-%mem | head)" >> $MESSAGE
 mail -s "$SUBJECT" "$TO" < $MESSAGE
 rm /tmp/Mail.out
fi
