#!/bin/bash
# Escribir un script que reciba varios nombres de archivo como parámetros, para cada uno valide si el nombre corresponde a un 
# archivo común existente, y si es así lo muestre en pantalla paginando (con el comando more). En caso de que el parámetro
# de entrada no sea un fichero, el script deberá escribir por pantalla “<parámetro> no es un fichero.
#
# Loops through the script parameters list ($@).
for i in "$@"
do
	# If file exists, more is executed.
	if [ -f "$i" ]
	then more "$i"
	else echo "$i no es un fichero"
	fi
done
