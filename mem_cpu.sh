#!/bin/bash
# Shell script to monitor or watch the high Mem-load
# It will send an email to $ADMIN, if the (memroy load is in %) percentage of Mem-load is >= 80%

# you don't need this, $HOSTNAME is a system variable and
## already set.
#HOSTNAME=`hostname`

#Use lowercase variable names to avoid name collision with system variables. 
load=80
mailer=/bin/mail
mailto="olanreaz@ucmail.uc.edu, hortongn@ucmail.uc.edu "

if free -t | awk -vm="$load" 'NR == 2 { if($3/$2*100 > m){exit 0}else{exit 1}}'; then
 
  cores=$(grep -c processor /proc/cpuinfo)
  cpuPerc=$(ps -eo pcpu= | awk -vcores=$cores '{k+=$1}END{printf "%.2f", k/cores}')
  ## Get the more actual value for reporting
  memPerc=$(free -t | awk 'FNR == 2 {printf("%.2f%"), $3/$2*100}')

  message=$(cat <<EoF
Please check your processess on $HOSTNAME the value of cpu load is $cpuPerc & Current Memory Utilization is: $memPerc.
$(ps axo %mem,pid,euser,cmd | sort -nr | head -n 10)
EoF
         )
  printf '%s\n' "$message" | 
    "$mailer" -s "Memory Utilization is High > $load%, $memPerc % on $HOSTNAME" \
     "$mailto"
fi
