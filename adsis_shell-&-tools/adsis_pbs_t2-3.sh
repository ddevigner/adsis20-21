#!/bin/bash
# Tenemos un directorio que contiene, entre otras cosas, scripts de shell. Se desea modificarlos, insertando entre su primera y segunda línea el copyright 
# del autor y la fecha:
if [ $# -ne 2 ]; then echo -e "\nusage: ./shell_tools_2.1.sh <files_directory> <licence_file> \n"; exit 1; fi
if [ ! -d $1 ]; then echo "$1 no es un directorio."; exit 1; fi
if [ ! -f $2 ]; then echo "$2 no es un fichero leible."; exit 1; fi

for i in $(ls $1)
do
    if [ -f $i ]; then sed "1a# $(<$2)\n# $(date)\n" $i; fi
done