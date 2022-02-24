#!/bin/bash
# Se desea programar un script en bash que reciba un fichero con una lista de usuarios, un usuario por línea, como parámetro de 
# entrada y determine si el usuario existe en el sistema. En caso afirmativo, el script revisará los permisos del directorio .ssh 
# verificando si son correctos. Cuando los permisos sean incorrectos, se mostrara un mensaje de error por pantalla y si el usuario 
# no pertenece al sistema se borrara el directorio /home/usuario si existe.
#
if [ $# -ne 1 ]; then echo "Usage: $0 fichero_usuarios"; exit 1; fi
for user in $(<$1)
do
    grep -q "$user:" /etc/passwd
    if [ $? -ne 0 ]
    then
        echo "error -- usuario inexistente: $user"
        find / -type d -name "$user" &> /dev/null
        if [ $? -eq 0 ]; then rm -rf $home; echo "eliminando home. . ."; fi
    else 
        echo "usuario: $user"
        ssh_fdr=$(eval echo "~$user")/.ssh
        if [ -d $ssh_fdr ]
        then 
            if [ "$(stat -c %U $ssh_fdr)" != $user ]; then echo "error -- distinto propietario: $ssh_fdr" >&2
            elif [ "$(stat -c %a $ssh_fdr)" != "700" ]; then echo "error -- ${home}/.ssh permisos incorrectos." >&2
            else 
                bad=0
                for file in ${ssh_fdr}/*
                do
                    echo -n "├─── $file ... "
                    if [ "$(stat -c %a $file)" == "600" ]; then echo "OK"
                    else 
                        echo "BAD"
                        bad=$((bad + 1))
                    fi
                done
                if [ $bad -eq 0 ]; then echo "todo en orden con \"${ssh_fdr}\" -o-)7"
                else echo "error -- $bad ficheros con permisos incorrectos. ToT)7"
                fi
            fi
        else echo "error -- ${home}/.ssh inexistente."
        fi
    fi
done