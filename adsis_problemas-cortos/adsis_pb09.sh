#!/bin/bash
# Siguiendo con el ejemplo anterior, escribe un script para mostrar los usuarios de un sistema agrupados por su shell por defecto. Para 
# el siguiente fichero de entrada:
#     "nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin"
#     "syslog:x:101:104::/home/syslog:/bin/false"
#     "messagebus:x:102:106::/var/run/dbus:/bin/false"
# La salida debería ser:
#     shell /usr/sbin/nologin
#     nobody
#     shell /bin/false
#     syslog
#     messagebus
#
sort -t ':' -k7 /etc/passwd | awk -F ':' '
    BEGIN { shell="" }
    {
        if(shell != $7){ printf "\nshell %s\n",$7; shell=$7 }
        printf "\t%s\n",$1
    }
    '