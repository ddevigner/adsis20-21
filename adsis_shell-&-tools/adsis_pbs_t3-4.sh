#!/bin/bash
# Tenemos en un sistema tipo UNIX a una serie de usuarios ya creados. Hemos visto que algunos de ellos tienen su cuenta invadida 
# por personas sin derecho a usar el equipo. Una cuenta está invadida si en el home del usuario hay un directorio llamado ".rootkit".
# Este es un ejemplo del fichero de configuración de usuarios (/etc/passwd):
# 
# jperez:x:10912:1009:Juan Perez,,,:/home/jperez:/bin/bash
# mfernan:x:10913:1009:Manuel Fernandez,,,:/home/mfernan:/bin/bash
# mgarcia:x:10914:1009:Maria Garcia ,,,:/home/mgarcia:/bin/bash
# lruiz:x:10915:1009:Luis Ruiz ,,,:/home/lruiz:/bin/bash
# 
# Queremos un script que reciba como primer parámetro el fichero de configuración de usuarios y que para cada cuenta:
# 1. Si está invadida, imprima un mensaje de alerta, la cancele (usando el comando correspondiente) y mueva el home del usuario al 
# directorio /invadidos/
# 
# 2. Si no está invadida, nos diga desde que máquina se conectó el usuario la última vez. Para esto puede usarse el comando finger, 
# que para usuario que han usado alguna vez la cuenta muestra algo como esto:
#
# $ finger mgarcia
# Login: mgarcia Name:
# Directory: /home/mgarcia Shell: /bin/bash
# Last login Sun Jun 13 15:59 (CEST) on pts/14 from sumaquina.com
# No mail.
# No Plan.

if [ $EUID -ne 0 ]; then echo "requieres de permisos de administrador o ser root."; exit 1; fi
# if [ ! -d "/invadidos" ] mkdir /invadidos

for i in $(awk -F ':' '{print $1}' /etc/passwd)
do
    home_dir=$(eval echo "~$i")
    if [ -d ${home_dir}/.rootkit ]
    then 
        echo "warning -- invaded account: $i";
        #mv ~$i /invadidos/
        #userdel -f $i 
        #passwd -l $i
    else
       echo -e "$(finger $i | awk 'NR==3')\t$i"
    fi
done