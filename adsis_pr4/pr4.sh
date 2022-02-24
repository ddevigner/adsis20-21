#!/bin/bash
# Realizar un script que permita añadir y suprimir un conjunto de usuarios especificados en un fichero (mismo formato que práctica 3) 
# a un conjunto de máquinas especificadas mediante sus direcciones IP en otro fichero, una IP por línea. Es decir, el script realizará 
# la misma acción de creación/borrado de usuarios para todos los usuarios del fichero en cada máquina del conjunto. El proceso ha de ser 
# completamente automático, sin interacción del administrador. No se debe solicitar ningún password al ejecutar el script (ni debe 
# haber ningún password escrito en ningún fichero, obviamente).
# 
# La sintaxis del script practica_4.sh debe ser: practica_4.sh [-a|-s] <fichero_usuarios> <fichero_máquinas> y si el script no 
# puede conectarse a una máquina el mensaje de error deberá ser: “<nombre_maquina> no es accesible”. Para el resto de errores, 
# se deberá mostrar el mensaje correspondiente de la práctica 3.
#
if [ $# -eq 3 ]
then
    if [ $1 = "-a" -o $1 = "-s" ]
    then
        while IFS= read -r IP
        do  
            ssh -n as@${IP} "exit" &> /dev/null
            if [ $? -eq 0 ] 
            then 
                scp pr4_core.sh ./$2 as@${IP}:~/ &> /dev/null
                ssh -n as@${IP} "sudo ./pr4_core.sh $1 ./$2 && rm pr4_core.sh ./$2 && exit"
            else echo "${IP} no es accesible"
            fi
        done < $3
    else echo "Opcion invalida" 1>&2
    fi
else echo "Numero incorrecto de parametros"
fi


