#!/bin/bash
# Escribir un script que pida introducir la ruta de un directorio por teclado y muestre cuantos archivos y cuantos directorios hay 
# dentro de ese directorio (sin aplicar recursividad en ambos casos). En caso de que la ruta leída no se corresponda con un directorio, 
# el script escribirá por pantalla el siguiente mensaje:
# 	"<ruta_leida> no es un directorio"
# Una vez determinados el número de ficheros y directorios, el script mostrará el siguiente mensaje:
# 	"El numero de ficheros y directorios en <dir> es de <num_files> y <num_dirs>, respectivamente"
#
# User introduces his desire directory.
read -p "Introduzca el nombre de un directorio: " DIR

# Checks if the obtained name is a directory and exists.
# -> If it is, counts the file and directory number contained.
# -> If not, try it with another name! Or not...
if [ ! -d "$DIR" ]
then echo "$DIR no es un directorio"
else
	# ls -p forces an output where directories are shown with the final /, if we count
	# the number of appearances of filtered files without this final bar (with grep and wc),
	# we could get the contained files number.
	n_files=$(ls -p "$DIR" | grep -v \/$ | wc -l)

	# ls -l shows more information about the files included in the current directory,
	# each one in a new line, more specifically, the permissions. A directory, in its
	# permissions has a "initial d" determining that is a directory. Counting the
	# appearance of theese "initial d" determines the number of directories.
	n_dirs=$(ls -l "$DIR" | grep ^d | wc -l)
	echo "El numero de ficheros y directorios en $DIR es de $n_files y $n_dirs, respectivamente"
fi
