#!/bin/bash

function setTimeZone {
    if [ -f "/etc/timezone.host" ]; then
        CLIENT_TIMEZONE=$(cat /etc/timezone)
        HOST_TIMEZONE=$(cat /etc/timezone.host)

        if [ "${CLIENT_TIMEZONE}" != "${HOST_TIMEZONE}" ]; then
            echo "Reconfigure timezone to "${HOST_TIMEZONE}
            echo ${HOST_TIMEZONE} > /etc/timezone
            dpkg-reconfigure -f noninteractive tzdata
        fi
    fi
}

touch /var/log/fail2ban.log
touch /var/log/auth.log
setTimeZone
service fail2ban stop
rm -f /var/run/fail2ban/*
service fail2ban start
tailf /var/log/fail2ban.log