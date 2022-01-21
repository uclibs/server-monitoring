#!/bin/bash

Date = `date +% F" "% H:% M`

IP = `ifconfig eth0 | awk '/inet addr/{print $ 2}' | cut -d: -f2`

Total = `fdisk -l | grep" Disk/dev/sd [az] "| awk '{print $ 2 $ 3" GB "}' | sed 's/:/=/' | xargs echo -n | sed 's/[]/,/g'` # newline removed, separated by a comma in the message displays the total size of each partition

Disk_Use = `df -h | awk '{print $ 1" = "$ 5}' | sed '1d' | sed 's/%//g'`

for i in $ Disk_Use

do

        A = `echo $ i | awk -F '=' '{print $ 2}'`

        if [$ A -gt 8]; then

                echo -e "Date: $ Date\nHost: $ IP\nTotal: $ Total\nProblem: Part Use $ {i}%" | mail -s "Disk Monitor " olanreaz@ucmail.uc.edu      

 fi

done
