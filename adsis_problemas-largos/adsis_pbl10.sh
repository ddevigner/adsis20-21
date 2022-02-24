#!/bin/bash
# Además desea saber cuales son los módulos más empleados. Para ello requiere de un único script que, durante 24 horas, empezando a las 6 de la mañana, compruebe cada 2 
# horas los módulos que estén usados 3 o más veces. Todos los módulos que cumplan la condición durante las 12 comprobaciones, serán añadidos a una lista que deberá 
# enviarse por mail al usuario user con asunto “módulos más empleados”. La lista estará ordenada alfabéticamente.
# Notas:
#     • Se puede asumir que el script se ejecuta con privilegios de administración.
#     • El comando date permite conocer la fecha y la hora actual
#     • Si se desea se puede emplear el fichero /var/run/modules.txt como almacenamiento temporal
#     • La opción -s del comando tr reemplaza múltiples ocurrencias de un carácter repetido por una única ocurrencia.
#     • El comando rmmod descarga un módulo del sistema
#     • El comando lsmod muestra los módulos cargados del kernel y tiene el siguiente formato:
#         "Module         Size    Usedby"
#         "fuse           98304   3"
#         "iptable_filter 16384   0"
# 
# CRONTAB
# 0 6,8,10,12,14,16,18,20,22,0,2,4 * * * /path/scrip.sh
current_date=$(date +"%d\/%m\/%Y-%H:%M");
if [ "$(echo $current_date | cut -d'-' -k2)" -eq "06:00" ]; then
    cat /var/run/modules.txt | sort -k2 | awk '
        {
            if(module != $2){ module = $2; times=0; }
            if($3 >= 3){ 
                times++; 
                if(times == 12) print $2
            }
        }'
    lsmod | sed "s/^/$current_date &" > /var/run/modules.txt
fi
lsmod | sed "s/^/$current_date &">> /var/run/modules.txt