#!/bin/bash
# Un administrador quiere minimizar el uso de recursos por parte del kernel de Linux y necesita un script que compruebe una vez cada hora todos los módulos del 
# kernel que están cargados y descargue aquellos que no estén en uso, es decir aquellos para los que el valor de la columna Used by sea igual a 0.
# 
lsmod | sed '1d' | awk '{if($3==0) print $1}' | while read -r module; do modprobe -r $module; done

