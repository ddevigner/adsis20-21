#!/bin/bash
# Escribir un script que copie todos los programas del directorio actual (archivos ejecutables) hacia un nuevo subdirectorio temporal 
# cuyo nombre siga el siguiente patrón, binXXX (siendo X un carácter alfanumérico), y se encuentre en el directorio raíz del usuario. 
# Durante la ejecución, el script mostrará los nombres de los ficheros copiados e indicará su número o que no ha movido ninguno. Si en 
# el directorio raíz del usuario ya existieran uno o varios directorios que siguieran el patrón, hay que utilizar el que haya sido menos 
# recientemente modificado.
#
# -> ls -dltr lists all "binXXX" directories coincidences in "last time modified" ascendent order,
# meant that the first directory will be the destination directory.
#
# -> head -n 1 gets the first directory entry, and tail -c N gets the directory name (8 because of
# "binXXX\n", the directory name is at the end of the entry).
#
# -> 2> /dev/null avoids the error msg if there's not any coincidence.
currentDIR=$(pwd)
cd
rootDIR=$(pwd)
cd $currentDIR

binXXX=$(ls -dltr $rootDIR/bin[[:alnum:]][[:alnum:]][[:alnum:]] 2> /dev/null | head -n 1 | tail -c $((${#rootDIR} + 8)))

# If binXXX not defined (not founded a coincidence), makes new "binXXX" folder.
if [ "$binXXX" = "" ]
then
	binXXX=$rootDIR/bin$(head /dev/urandom | tr -dc '[[:alnum:]]' | head -c 3)
	mkdir "$binXXX"
	echo "Se ha creado el directorio $binXXX"
fi
echo "Directorio destino de copia: $binXXX"

# Copies all listed files in current directory that are executable into "binXXX" directory.
# Avoids directories' recurrence.
copied_files=0
for i in $(ls)
do
	# If executable and not directory, copies the file and increases by one, copied_files.
	if [ -x $i -a ! -d $i ]
	then
		cp $i $binXXX
		copied_files=$(($copied_files+1))
		echo "./${i} ha sido copiado a $binXXX"
	fi
done

# If copied_files == 0, there was not any executable.
# If not, there was, at least, one.
if [ $copied_files -eq 0 ]
then echo "No se ha copiado ningun archivo"
else echo "Se han copiado $copied_files archivos"
fi
