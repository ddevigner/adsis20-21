#!/bin/bash
# ¿Cuál es el objetivo del siguiente script? Sacar por pantalla la lista de todas las palabras diferentes (sin repeticiones), de un
# fichero, ordenadas alfabeticamente en minuscula.
#
E_BADARGS=85
if [ ! -r "$1" ]
then
    echo "Usage: $0 files-to-process"
    exit $E_BADARGS
fi

cat "$@" |  # Mostrar contenido de los ficheros.
tr A-Z a-z |    # Sustituir mayusculas por minusculas.
tr ' ' '\012' | # Sustituir todos los espacios por nueva linea.
tr -c '\012a-z' '\012' |   # Sustituir todo lo que no sea nueva linea o minuscula por nueva linea.
grep -v '^$' |  # Filtrar todas las lineas que no sean vacias.
sort |  # Ordenarlas alfabeticamente.
uniq    # Mostrarlas una vez.
exit $?
