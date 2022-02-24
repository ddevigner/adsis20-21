#!/bin/bash
# Programar un script que extienda la capacidad de un grupo volumen añadiéndole particiones. El grupo volumen será el primer parámetro del script y el resto de los 
# parámetros serán las particiones a añadir. El grupo volumen tendrá el nombre de vg_p5. 
#
# ERROR LOG MESSAGE:
if [ $EUID -ne 0 ]; then
    printf "\nerror -- quizas los privilegios de administrador ayuden, graciasss.\n"
    printf "\nusage: sudo ./practica_5_parte3_vg.sh <vg> <d0> ... <dn>\n"
    exit 1
fi
if [ $# -lt 2 ]; then 
    printf "\nerror -- creo que el numero de parametros no es suficiente.\n"
    printf "\nusage: sudo ./practica_5_parte3_vg.sh <vg> <d0> ... <dn>\n"
    printf "\t<vg>\tVolume Group name.\n\t<dn>\tDevice for extension.\n\n"
    exit 1
fi
vg_name=$1                  # Saving VG NAME.
shift                       # Because we are LOOSING IT.
vgextend $vg_name $@   # And now, LETS EXTEND THE VG.