#!/bin/bash
# Escribir un script que nos pida pulsar una tecla escribiendo por pantalla el mensaje:
#	"Introduzca una tecla: "
# y nos diga si la tecla pulsada es una letra, un número o un carácter especial. Si el usuario pulsa más de una tecla, se ignorarán 
# todas menos la primera letra pulsada.
#
# User introduces his desired key. "key_input" saves the input's first char.
read -p "Introduzca una tecla: " key_input
key_input=${key_input:0:1}

# Checks if "key_input" is a letter. If not, is a number or a special char.
if [[ $key_input =~ [A-Za-z] ]]
then echo "$key_input es una letra"
else
	# Checks if "key_input" is a number. If not, is a special char.
	if [[ $key_input =~ [0-9] ]]
	then echo "$key_input es un numero"
	else echo "$key_input es un caracter especial"
	fi
fi
