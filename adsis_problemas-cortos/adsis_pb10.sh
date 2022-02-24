#!/bin/bash
# Realiza un script que muestre por pantalla todos los directorios que ha visitado un usuario y que todavía sean válidos. El nombre de 
# usuario será un parámetro del script. Para el cálculo de las rutas podrás asumir que el primer directorio visitado fue el $HOME del 
# usuario y sólo se mostrarán los directorios que hayan sido accedidos con cd y que se encuentren en la historia del usuario. La salida 
# sólo deberá mostrar las rutas canónicas de todos los directorios visitados cuyas rutas sean absolutas, empiecen por /, o empleen la 
# expansión de tilde con ~ y ~+.
#
id -u as &>/dev/null
if [ $? -ne 0 ]; then echo "usuario \"$user\" inexistente."; exit 1; fi

user_home=$(eval echo "~$1")
current_dir=$(pwd)
cd $user_home
echo "user movement history:"
echo "├───$user_home"

while read -r path
do
    cd $path &>/dev/null
    if [ $? -eq 0 ]; then echo "├───$(pwd)"
    else echo "├─── <\"$(pwd)/$path\" not found>"
    fi
done < <(sed -nr 's/(cd [^ ]*)/\n\1/p' ${user_home}/.bash_history | grep cd | awk '{print $2}')
cd $current_dir