#!/bin/bash
# Se disponen de 10 discos duros (/dev/sd[a-j]) con capacidad 1 terabyte cada uno y particionados con una única partición (/dev/sd[a-j]1). Fueron instalados para 
# disponer de un volumen lógico en el directorio /home del sistema. Para alargar su vida útil, se desea que sean empleados sólo cuando sea necesario hacerlo y que el 
# resto del tiempo no sean visibles en el sistema. El administrador encargado del mismo necesita un script para agrandar el volumen lógico /home cada vez que esté lleno 
# en más de un 90%. Esta comprobación se realizará cada 10 minutos y si es positiva habrá que añadir un disco al volumen lógico. Cuando ya estén en uso todos los discos 
# duros, el script deberá mandar un email a los 10 usuarios que más espacio en disco estén consumiendo pidiéndoles que reduzcan su uso de espacio, el email se seguirá 
# enviando indefinidamente mientras que la utilización de espacio siga por encima del 90%. Escribe por favor el script o los scripts necesarios para cumplir esta tarea.
# 
# Notas:
#     • Se deberá asumir que, al principio de la ejecución del programa, sólo se está usando /dev/sda1.
#     • Los nombres del grupo volumen y del volumen lógico donde está montado la carpeta home son vg_pool y lv_home y el tipo de la partición del directorio /home 
#       es ext4.
#     • Todos los usuarios tienen su home en el directorio /home/<usuario>
#     • El comando du tiene la opción –d que limita el número de sub-directorios que se muestran por pantalla. Por ejemplo –d0 sólo muestra por pantalla el uso de 
#       espacio del directorio/os pasado/os como argumentos. La salida incluye un argumento por línea.
# 
# crontab -e
# */10 * * * * path/prl4.sh

check_disks(){
    echo $(pvs --noheadings /dev/sd[b-j]1 | grep -v '/dev/sd[b-j]1[ ]*vg_pool' | head -n 1 | sed 's/ //g')
}

check=$(df -h --output='source','pcent' | awk '/lv_home/ {if($2 <= 90){print 0} else print 1}')
if [ $check -eq 1 ] 
then
    next_disk=$(check_disks())
    if [ ! -z next_disk ]
    then 
        vgextend vg_pool $next_disk
        lvextend -L+1TB lv_home
        resize2fs lv_home
    else
        users=$(du -sh /home/* | sort -rh | head -n 10 | cut -f2 | awk -F'/' '{print $NF}')
        echo "Por favor, el excesivo espacio consumido por su cuenta compromete el espacio total, por favor, baje el espacio" | mail -s "ESPACIO INSUFICENTE" ${users[@]}
    fi
fi