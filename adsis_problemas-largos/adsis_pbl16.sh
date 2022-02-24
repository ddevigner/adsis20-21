#!/bin/bash
# Realiza un script que dada una lista de ficheros de entrada como argumentos busque la línea de mayor longitud entre todos los ficheros legibles. La salida del script 
# mostrará para la linea más larga, el nombre del fichero, el número de línea y su contenido, por ejemplo:
#     busca_linea_max_longitud.sh fichero1.txt fichero2.txt fichero3.txt fichero1.txt, 5, hola qué tal?, muy bien
# Notas:
#     • En caso de haber varias líneas de máxima longitud iguales, se mostrará únicamente la primera.
#     • Si el script no recibe ningún argumento, terminará sin devolver ningún mensaje.
#     • Los ficheros no legibles serán ignorados sin devolver ningún mensaje.
# 
re='\.txt$'
for file in "$@"
do
    if [[ $file =~ $re ]]; then txtfiles+=($file); fi
done
awk 'BEGIN {L=0} { if(length > L){ L=length; line=$0; file=FILENAME } } END { printf "%s, %d, %s\n",file,L,line}' ${txtfiles[@]}
