#!/bin/bash
# El comando lastb muestra una salida tipo:
#     "root ssh:notty 222.186.160.49 Fri May 29 11:33 - 11:33 (00:00)"
#     "root ssh:notty 222.186.160.49 Fri May 29 11:33 - 11:33 (00:00)"
#     "root ssh:notty 222.186.160.49 Fri May 29 11:33 - 11:33 (00:00)"
#     "root ssh:notty lubov3110.static Fri May 29 11:33 - 11:33 (00:00)"
# Con los datos de los intentos de login fallidos. Las columnas indican el usuario, TTY donde se intentó logear, IP o host desde el que se intentó la conexión, 
# fecha del intento, y duración de la sesión (00:00). Escribir un script que revise la salida de este comando y muestre por pantalla el nombre del usuario y el día 
# cuando el usuario tenga más de 10 intentos fallidos de login en el mismo día. Además deberá programarse la ejecución del script todos los días a las 23:59 horas y 
# se enviará un email con la lista de dichos usuarios a root.
# 
lastb | sort | awk '
    {
        if ($1 == user){
            if ($4 == n_dow && $5 == month && $6 == day){
                times++;
                if(times > 10){ print user": "n_dow" "month" "day; i++}
            }
            else{ n_dow=$4; month=$5; day=$6; times=0 }
        }
        else{ user = $1; times=0 }
    }
    ' | uniq | mail -s "Usuarios que no lo han conseguido..." root