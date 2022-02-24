#!/bin/bash
# Dado un fichero con nombres y apellidos, generar una dirección de correo @unizar para cada línea, que contenga la primera letra del nombre y todo el apellido.
# Version sed
#sed -r 's/^(.)[[:alpha:]]+[ ]([[:alpha:]]+)/\1\2@unizar.es/' $1 | tr [A-Z] [a-z]

# Version awk
awk '{print tolower(substr($1,0,2) $2 "@unizar.es") }' $1