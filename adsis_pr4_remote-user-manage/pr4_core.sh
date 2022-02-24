#!/bin/bash
# Script de la practica 3 adaptado a la practica 4.
#
if [ $EUID -ne 0 ]; then echo "Este script necesita privilegios de administracion"; exit 1; fi
if [ $# -eq 2 ]
then
    # ADD USER
    if [ $1 = "-a" ]
    then
        # READING USER PER USER
        while IFS= read -r user
        do
            IFS=,
            read -ra user_fields <<< "$user"
            if [ ${#user_fields[@]} -ne 3 ]; then exit 1; fi
            for i in "${user_fields[@]}"
            do 
                if [ -z i ]; then echo "Campo invalido"; exit 1; fi
            done
            # ADDING NEW USER
            useradd -m -k /etc/skel -U -K UID_MIN=1815 -c "${user_fields[2]}" "${user_fields[0]}" &>/dev/null
            if [ $? -eq 0 ]
            then
                usermod -aG 'sudo' ${user_fields[0]}
                passwd -x 30 ${user_fields[0]} &>/dev/null
                echo "${user_fields[0]}:${user_fields[1]}" | chpasswd
                echo "${user_fields[2]} ha sido creado"
            else echo "El usuario ${user_fields[0]} ya existe".
            fi
        done < $2
    # DELETE USER
    elif [ $1 = "-s" ]
    then
        # BACKUP DIRECTORY CREATION
        if [ ! -d /extra ]; then mkdir -p /extra/backup
        elif [ ! -d /extra/backup ]; then mkdir /extra/backup
        fi
        # READING USER PER USER
        while IFS= read -r user
            do
                IFS=,
                read -ra user_fields <<< "$user"
                if [ ${#user_fields[@]} -ne 1 -a ${#user_fields[@]} -ne 3 ]; then exit 1; fi
                for i in "${user_fields[@]}"
                do 
                    if [ -z i ]; then echo "Campo invalido"; exit 1; fi
                done
                # ADDING NEW USER
                user_home="$(getent passwd ${user_fields[0]} | cut -d: -f6)"
                tar cvf /extra/backup/${user_fields[0]}.tar $user_home &>/dev/null
                if [ $? -eq 0 ]; then userdel -f ${user_fields[0]} &>/dev/null; fi
            done < $2
    # INVALID OPTION
    fi
else echo "Numero incorrecto de parametros"
fi

