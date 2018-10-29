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
touch /var/log/apache2/access.log
touch /var/log/apache2/error.log
touch /var/log/mysql/error.log
setTimeZone
service fail2ban stop
rm -f /var/run/fail2ban/*
docker=$(ip addr|awk '/docker/ && /inet/ {gsub(/\/[0-9][0-9]/,""); print $2}'); sed -i "/^ignoreip =/ s/$/ ${docker}\/8/" /etc/fail2ban/jail.local
bridge=$(ip addr|awk '/br-/ && /inet/ {gsub(/\/[0-9][0-9]/,""); print $2}'); sed -i "/^ignoreip =/ s/$/ ${bridge}\/8/" /etc/fail2ban/jail.local
service fail2ban start
tailf /var/log/fail2ban.log