#!/bin/bash
# Escribe un script para añadir un nodo al fichero /etc/hosts verificando que el nodo es accesible y que no exista ya en el fichero.
#
if [ $# -ne 2 ]; then echo -e "error -- parametros insuficientes.\n\nusage sudo $0 <ip> <domain>\n"; exit 1; fi
check=$(awk -v i=$1 -v n=$2 '
    BEGIN {enough=0}
    {
        if(enough == 0){
            if(i == $1){ printf "error -- direccion ip %s ya definida en la linea %d: %s %s\n",i,NR,$1,$2; enough=1 }
            else if(n == $2){ printf "error -- nombre %s ya definido en la linea %d: %s %s\n",n,NR,$1,$2; enough=1 }
            else{print 0; enough=1}
        }
    }
    ' /etc/hosts)
if [ "$check" == "0" ]; then echo "$1 $2" >> /etc/hosts
else echo $check; fi