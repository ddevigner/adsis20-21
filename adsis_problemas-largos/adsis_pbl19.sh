#!/bin/bash
# Para verificar que los usuarios de un sistema emplean contraseñas seguras, realiza un script que busque en un nodo dado si los usuarios cuyo UID sea mayor o igual 
# a 1000 emplean contraseñas inseguras. El script recibirá como argumentos una dirección IP y un fichero con las contraseñas inseguras a probar, una por línea. Al 
# terminar la búsqueda, el script enviara un correo al usuario root del nodo donde se esté probando el script con a lista de usuarios cuya contraseña haya sido 
# encontrada. El asunto del correo será “usuarios con mala contraseña”. Cuando los argumentos sean inválidos, el script devolverá 1 y terminara escribiendo: 
# “sintaxis invalida” por pantalla. 
# 
# Notas:
#     • Se puede suponer que el usuario as puede acceder a cualquier nodo mediante clave pública sin password.
#     • El comando sshpass permite escribir el password de ssh de manera no interactiva. Una posible manera de utilización sería:  
#           $ SSHPASS=<contraseña> sshpass –e ssh <usuario>@<nodo> <comando> - El formato del fichero /etc/password es: Usuario:password encriptado:UID.GUD
#  
if [ $# -ne 2 ]; then echo "sintaxis invalida"; exit 1; fi
if [ ! -e $2 ]; then exit 1; fi
ssh as@$1 'logout'
if [ $? -ne 0 ]; then exit 1; fi
while read -r user
do
    while read -r passwd
    do
        SSHPASS=$passwd sshpass -e ssh ${user}@${$1} 'logout' &> dev/null
        if [ $? -eq 0 ]; then insecure_users+=($user); fi
    done < $2
done < <(ssh as@$1 "cat /etc/passwd | awk -F':' '{if(\$3 >= 1000) print \$1}'")
printf "Node %s:\n %s\n" $1 ${insercure_users[@]} | mail -s "INSECURE USERS IN NODE" root

