#!/bin/bash
# Realizar un script que compruebe remotamente (mediante ssh) la situación de uso y organización de espacio de disco, volúmenes lógicos, sistemas de ficheros y 
# directorios de montaje. Como resultado, el script enviará a salida estándar (cada elemento en una línea):
#     • Los discos duros disponibles y sus tamaños en bloques. Utilizar para ello el comando sfdisk –s.
#     • Las particiones y sus tamaños. Utilizar para ello el comando sfdisk –l.
#     • Información de montaje de sistemas de ficheros (salvo tmpfs): partición o volumen lógico, tipo de sistemas de ficheros, directorio de montaje, tamaño, espacio 
#       libre (df -hT).
# El script tomara una dirección IP como parámetro.
#
if [ $# -ne 1 ]; then 
    printf "\nerror -- creo que el numero de parametros no es suficiente.\n"
    printf "\nusage: sudo ./practica_5_parte2.sh <IP> \n"
    printf "\t<IP>\tDireccion ip de la maquina.\n\n"
    exit 1
fi
ssh as@"$1" "sudo sfdisk -s && sudo sfdisk -l && sudo df -hT | grep -vE 'udev|tmpfs'"
