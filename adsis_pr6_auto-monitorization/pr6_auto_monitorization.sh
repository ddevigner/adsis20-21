#!/bin/bash
# Desarrollar un script en bash que se ejecute de manera local y que extraiga información de monitorización de una máquina con los 
# siguientes programas:
#   • uptime (nº usuarios y carga media de trabajo)
#   • free (memoria ocupada y libre, swap utilizado)
#   • df (espacio ocupado y libre)
#   • netstat (nº de puertos abiertos y conexiones establecidas)
#   • ps (número de programas en ejecución)
#
# La información relevante recogida con los anteriores comandos en cada máquina será registrada en rsyslog a través de logger y la 
# configuración de rsyslog.conf con tipo de programa “local0” y prioridad de mensaje “info”. 
#
# Para centralizar la monitorización, una máquina deberá transmitir, con rsyslog y a través de la red, su información a la otra máquina, 
# que registrará la información de ambas máquinas en el fichero /var/log/monitorizacion. 
#
# La ejecución de extracción de información y logger se realizará periódicamente  mediante cron (1 minuto). 
# 
# Lo que se ejecute en cron tendrá tanto la salida de error como la salida estándar redirigida a /dev/null para no enviar emails.
#
#CONNECTED_USERS: n
#AVERAGE_LOAD: n(1min), n(5min), n(15min)
uptime | cut -d',' -f2,3,4,5 | grep -Eo '([0-9]+|[0-9]+[.][0-9]+)' | tr ['\n'] [" "] | awk '
    BEGIN { printf "#CONNECTED_USERS: %d\n",$1}
    {printf "#AVERAGE_LOAD: %.2f(1min), %.2f(5min), %.2f(15min)\n",$2,$3,$4}' | logger -p local0.info

#USEDmem/FREEmem=nMB/mMB
#USEDswap=nMB  
free --mega | sed '1d' | awk '{if(NR==1) printf "#USEDmem/FREEmem: %sMB/%sMB\n",$3,$4; if(NR==2) printf "#USEDswap: %sMB\n",$3 }' | logger -p local0.info

#DF.LOG={
#---> DEV: dev, USED_SPACE/AVAIL_SPACE: n/m
#...
#}
df -h --output='source','used','avail' | grep -Ev '(tmpfs|udev)' | sed '1d' | awk '{printf "#DISK: %s, USED_SPACE/AVAIL_SPACE: %s/%s\n",$1,$2,$3}' | logger -p local0.info

#OPENED_PORTS=op 
#ESTABLISHED_CONNECTIONS=ec
echo -e "#OPENED_PORTS: $(($(netstat -l | wc -l) - 4))\n#ESTABLISHED_CONNECTIONS: $(($(netstat -a | wc -l) - 4))" | logger -p local0.info

#RUNNING_PROCESSES=rp
ps -e | wc -l | awk '{printf "#RUNNING_PROCESSES: %d\n",$1}' | logger -p local0.info