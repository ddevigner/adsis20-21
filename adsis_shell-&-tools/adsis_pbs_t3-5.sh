#!/bin/bash
# Tenemos un directorio que contiene, entre otras cosas, scripts de shell. Se desea modificarlos, insertando entre su primera línea 
# y segunda el copyright del autor y la fecha. Por ejemplo, el programa
# 
# echo hola mundo
# -->
# # (c) Juan Garcia. You can redistribute this program under the terms of the GNU GPL.
# # mar abr 12 16:05:20 CEST 2005
# echo hola mundo
# 
# Escribir un script de shell bash que haga esta tarea. Se usará por ejemplo de la siguiente forma: 
# pon_licencia $HOME/fuentes $HOME/licencia.txt
# 
# • El primer parámetro indica el directorio donde están los fuentes. Todos llevan extensión .sh (en minúsculas).
# • La primera línea de cada script debe respetarse, podría no ser exactamente.
# • El mensaje de copyright es una única línea de texto, que está en el fichero que se pasa como segundo parámetro. La fecha es 
# la que proporciona el comando date. Ni el fichero con la licencia incluye la almohadilla ’#’ ni la salida del comando lo muestra.
# • El script debe comprobar que recibe exactamente 2 parámetros, que el primero es un directorio y el segundo un fichero legible. Si 
# alguno de estos requisitos no se cumple, se muestra por stderr un mensaje de error especificando el problema.

if [ $# -ne 2 ]; then echo -e "\nusage: ./shell_tools_2.1.sh <files_directory> <licence_file> \n" >&2 ; exit 1; fi
if [ ! -d $1 ]; then echo "$1 no es un directorio." >&2 ; exit 1; fi
if [ ! -f $2 ]; then echo "$2 no es un fichero leible." >&2 ; exit 1; fi

for i in $(ls $1)
do
    if [ -f $i ]; then sed "1a# $(<$2)\n# $(date)\n" $i; fi
done