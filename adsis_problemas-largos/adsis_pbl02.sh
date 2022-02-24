#!/bin/bash
# Escribe en bash una utilidad de copia de ficheros entre nodos utilizado scp/ssh. El script tendrá 3 o más argumentos. El primero será el usuario y la máquina destino, 
# por ejemplo: usuario@maquina.unizar.es. El segundo argumento será el nombre del directorio destino donde se desea copiar los ficheros y directorios. El resto de 
# argumentos serán el nombre de los ficheros y directorios a copiar. En caso de que un argumento sea un directorio hay que copiar todos los ficheros contenidos en él 
# pero no sus subdirectorios. En el destino todos los ficheros serán copiados en la misma carpeta eliminando el nombre del directorio cuando sea necesario. Para reducir 
# ancho de banda antes de copiar cada elemento, el script calculará la firma de los ficheros con md5, sintaxis md5sum fichero. Dicha firma será enviada al nodo destino 
# en donde se comprobará si el fichero ya existe y tiene la misma firma. Cuando el fichero no exista en el destino o la firma sea distinta, se copiará.
# 
# Nota: Se debe asumir que el usuario dispone de las claves ssh adecuadas para acceder a la máquina remota sin necesidad de introducir ningún password y que el 
# directorio destino también existe. Además se supondrá que ninguno de los ficheros a copiar puede ser modficado desde el comienzo del cálculo de la firma md5 y el final 
# de la copia al nodo destino.
# 
# ./prl2.sh usuario@maquina directorio_destino directorios...
# Fichero -> Fichero, Directorio -> Ficheros, no subdirectorios.

if [ ! $# -ge 2 ]; then echo "usage $0 usuario@maquina directorio_destino archivos..."; exit; fi
machine=$1; shift
remote_dir=$1; shift

ssh -n ${machine} "test -d $remote_dir";
if [ $? -ne 0 ]; then echo "directorio remoto inalcanzable, compruebe la direccion o el directorio dado."; exit; fi
for i in "$@"
do
    if [ -f $i ]
    then 
        #firma=$(md5sum $i | cut -d' ' -f1)
        echo $firma > ${i}.md5sum
        #scp ${i}.md5sum ${machine}:${remote_dir}
        #ssh $machine "cd ${remote_dir} && md5sum -c ${i}.md5sum"
        #if [ $? -eq 0 ]; then scp $i ${machine}:${remote_dir}; fi
        scp $i ${machine}:${remote_dir} > /dev/null
    else 
        if [ -d $i ]
        then 
            for j in ${i}/*
            do
                if [ -f $j ]
                then 
                    #firma=$(md5sum $j)
                    #scp $firma ${machine}:${remote_dir}
                    #if [ $? -eq 0 ]; then scp $j ${machine}:${remote_dir}; fi
                    scp $j ${machine}:${remote_dir} > /dev/null
                fi
            done
        fi
    fi
done