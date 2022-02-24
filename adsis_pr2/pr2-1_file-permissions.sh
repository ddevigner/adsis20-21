#!/bin/bash
# Escribir un script que pida un nombre de archivo al usuario mediante la cadena: “Introduzca el nombre del fichero: “
# e indique si el archivo es legible, modificable y ejecutable por el usuario. La salida del script será la siguiente según los posibles casos:
# 	• Fichero no existe: “<nombre fichero> no existe”
# 	• Fichero existente: “Los permisos del archivo <nombre fichero> son: [---|r--|-w-|--x|rw-|r-x|-wx]|rwx”
#
# User introduces his desired file.
read -p "Introduzca el nombre del fichero: " input_file

# Checks if input_file exists and is a file:
# -> If it is, checks its current permissions.
# -> If not, end of execution.
if [ ! -f "$input_file" ]
then echo "$input_file no existe"
else echo -n "Los permisos del archivo $input_file son: "

	# Is reabable?
	if [ -r "$input_file" ]
	then echo -n "r"
	else echo -n "-"
	fi

	# Is writable?
	if [ -w "$input_file" ]
	then echo -n "w"
	else echo -n "-"
	fi

	# Is executable?
	if [ -x "$input_file" ]
	then echo "x"
	else echo "-"
	fi
fi
