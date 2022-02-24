#!/bin/bash
# La computación serverless es un modelo de servicios en cloud en el que el proveedor es responsable del servidor y de la administración de los servicios y el cliente 
# únicamente paga por los dichos servicios consumidos. Un administrador necesita un script en bash que siguiendo el modelo serverless permita ejecutar scripts de bash y 
# ficheros binarios con ciertas restricciones en un nodo remoto. Podrías ayudar al administrador escribiendo dicho script cumpliendo la siguiente especificación:
#     • El script serverless.sh tendrá un único parámetro que debe ser un programa ejecutable, es decir, otro script bash o un fichero binario. Para comprobar la validez
#       del parámetro se deberá emplear el comando file y verificar que el tipo de fichero es ELF 64-bit LSB shared object o Bourne-Again shell script.
#     • Para su ejecución, el fichero deberá ser copiado al nodo 192.168.56.1 donde en caso de que sea binario deberá comprobarse con el comando ldd que están instaladas 
#       todas las bibliotecas dinámicas necesarias. Para ello es necesario asegurar que no aparece ‘not found al ejecutar dicho comando. Si aparece, la ejecución deberá 
#       ser abortada.
#     • Al copiar el fichero este deberá tener un nombre único para evitar sobreescrituras si varios clientes envian a ejecutar un script con el mismo nombre.
#     • La salida del comando serverless.sh contendrá las salidas standard y de error del comando del cliente.
#     • Para evitar sobrecargar el nodo, el script comprobará antes de lanzar el parámetro la carga del nodo 192.168.56.1 durante los últimos 5 minutos y si es mayor 
#       de .6, esperará 3 minutos antes de volver a lanzar el script o binario del parámetro.
# Notas adicionales:
#     • El usuario as tiene acceso al nodo 192.168.56.1 mediante ssh y clave pública.
#     • La salida del comando file es:
#         file /bin/ls -> /bin/ls: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked
#         file serverless.sh -> serverless: Bourne-Again shell script, ASCII text executable
#     • Dado un fichero binario, la salida del comando ldd es:
#         ldd /bin/wrong_ls
#         ldd /bin/ls
#         linux-vdso.so.1 (0x00007ffe5479c000)
#         libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007ffbf3106000)
#         libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007ffbf2d67000)
#         libwrong.so.6 => not found
#     • El segundo campo de /proc/loadavg es la carga del sistema durante los últimos 5 minutos.
#         cat /proc/loadavg
#         0.01 0.02 0.00 1/75 645
# 
# 
if [ ! -e $1 ]; then exit 1; fi 
if file $1 &>/dev/null | grep -Eq 'ELF 64-bit LSB shared object'; then
    sufix=$(ip a | grep '192.168.56.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-5][0-4])/' | sed 's/.$//' | cut -d'.' -f3,4)
    tmp_file=${sufix}_$(basename $1)
    cp $1 /tmp/$tmp_file
    while [ $(ssh as@192.168.56.1 'cat /proc/loadavg' | awk '{if($3 > 0.6) print 1; else print 0;}') -eq 1 ]; do sleep 3m; done
    scp /tmp/$tmp_file as@192.168.56.1:~as
    ssh as@192.168.56.1 "if ldd ~as/$tmp_file | grep -vq 'not found'; then sh ~as/$tmp_file"
    rm /tmp/$tmp_file

elif file $1 &>/dev/null | grep -Eq 'Bourne-Again shell script'; then 
    sufix=$(ip a | grep '192.168.56.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-5][0-4])/' | sed 's/.$//' | cut -d'.' -f3,4)
    tmp_file=${sufix}_$(basename $1)
    cp $1 /tmp/$tmp_file
    while [ $(ssh as@192.168.56.1 'cat /proc/loadavg' | awk '{if($3 > 0.6) print 1; else print 0;}') -eq 1 ]; do sleep 3m; done
    scp /tmp/$tmp_file as@192.168.56.1:~as
    ssh as@192.168.56.1 "sh ~as/$tmp_file"
    rm /tmp/$tmp_file
else exit 1
fi

