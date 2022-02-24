#!/bin/bash
# Programa un script que dado un directorio, busque aquellos ficheros que no hayan sido modificados en el último mes y los guarde en un 
# fichero tar. El nombre del fichero tar resultante contendrá un prefijo recibido como argumento seguido de guión bajo y de la fecha 
# actual. Opcional: en vez de un directorio, utilizar como entrada múltiples directorios. El script tendrá al menos 2 argumentos, el 
# primero será el prefijo y después se incluirán los nombres de los directorios de entrada.
#
prefix=$1
d=$(date +%d%m%y)
shift
for dir in "$@"
do
    tar -cvzf ${prefix}_${d}.tar.gz $(find $dir -mtime +30 2>/dev/null)
done
