#!/usr/bin/env bash

# vars #
disk="/dev/mapper/rhel-root" # disk to monitor
current_usage=$(df -h | grep ${disk} | awk {'print $5'}) # get disk usage from monitored disk
max_usage="85%" # max 85% disk usage
mail="hortongn@ucmail.uc.edu" # mail to sent alert to

# functions #
function max_exceeded() {

    # tell that mail is being sent
    echo "Max usage (${max_usage}) exceeded. Your disk usage is at ${current_usage}. Trying to send mail-alert..."

    # check if the mail program exist
    type mail > /dev/null 2>&1 || { 
        echo >&2 "Mail does not exist. Install it and run script again. Aborting script..."; exit; 
    }

    # if the mail program exist we continue to this and send the alert
    mailbody="Max usage (${max_usage}) exceeded. Your disk (${disk}) usage is at ${current_usage}."
    echo ${mailbody} | mail -s "Disk alert!" "${mail}"

    echo "Mail was sent to ${mail}"
}

function no_problems() {

    echo "No problems. Disk (${disk}) usage at ${current_usage}. Max is set to ${max_usage}."
}

function main() {

    # check if a valid disk is chosen
    if [ ${current_usage} ]; then
        # check if current disk usage is greater than or equal to max usage.
        if [ ${current_usage%?} -ge ${max_usage%?} ]; then 
            # if it is greater than or equal to max usage we call our max_exceeded function and send mail
            max_exceeded
        else
            # if it is ok we do nothing
            no_problems
        fi
    else
        # if the disk is not valid, print valid disks on system
        echo "Set a valid disk, and run script again. Your disks:"
        df -h
    fi
}

# init #
main
