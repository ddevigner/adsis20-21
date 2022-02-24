#!/bin/bash
# Escribir un script que reciba un único nombre de archivo en la línea de comandos, verifique que existe y que es un archivo común 
# (o regular), lo convierta en ejecutable para el dueño y el grupo y muestre el modo final mediante el comando stat (deberás buscar 
# el formato correcto). Si el fichero no existe, debes mostrar el mensaje de error: 
# 	"<nombre_archivo> no existe"
# En caso de recibir un número distinto de argumentos por la línea de comandos, el script imprimirá el siguiente mensaje de error: 
#	"Sintaxis: practica2_3.sh <nombre_archivo>"
#
# Checks if the execution syntax was correct:
# -> Correct syntax equals that exists just one parameter.
# -> If false, try it again!
if [ $# -gt 1 -o $# -eq 0 ]
then echo "Sintaxis: practica2_3.sh <nombre_archivo>"
else
	# -> If file exist, enables its execution permissions for user and group (chmod 110)
	#    and shows its permissions (stat --format "%A" "$1").
	# -> If not, try it with a existing file next time! Or not...
	if [ ! -f "$1" ]
	then echo "$1 no existe"
	else chmod 110 "$1" && stat --format "%A" "$1"
	fi
fi
