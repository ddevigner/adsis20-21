#!/bin/bash
# Ejercicios de shell-script 1
# Expresiones regulares
# Sustituir todas las ocurrencias de “No” por “XX”.
sed 's/No/XX/g' #prueba.txt

# Insertar “>>” al principio de cada línea de un texto
sed 's/^/>> &' #prueba.txt

# Eliminar los dos últimos caracteres de cada línea. 
sed 's/...$//' #prueba.txt

# Eliminar la extensión de un archivo (ejm: foo.txt → foo).
sed -e 's/[.][[:alnum::]*//' #prueba.txt

# Elimine todas las vocales de un texto.
sed 's/[aeiouAEIOU]/g' #prueba.txt

# Sustituya las letras mayúsculas por *.
sed 's/[AEIOU]/\*/g' #prueba.txt

# Sustituya los espacios seguidos por un sólo espacio (ejm: foo bar fooz → foo bar fooz)
sed 's/\ \{2,\}/ /g' #prueba.txt

# Elimine los 10 primeros caracteres de cada línea.
sed 's/^.\{0,10\}//g'

# Encuentre un número de teléfono en un texto, donde el teléfono puede ser con los formatos:
# 689 123 456 ó 689-123-456. Teniendo en cuenta que tiene que ser la misma expresión
# regular para los dos telefónicos, y que el primer dígito debe ser 6, 7 , 8 o 9.
sed -n '/[6-9]\([0-9]\)\{2\}([-]\([0-9]\)\{3\}\|[ ]\([0-9]\)\{3\}\)\{2\}/p'


# Tools
# Buscar en /etc/passwd usuarios del sistemas con id > 99
awk -F ':' '$3>99' /etc/passwd

# Ordenar los usuarios del apartado anterior por id. 
awk -F ':' '$3>99' /etc/passwd | sort -n -t ":" -k3

# Dado un fichero con nombres y otro con apellidos, unir los dos ficheros y dejar sólo una de
# las personas con apellido repetido, mostrando cuantas personas de cada familia hay.
paste -d ' ' nombres.txt apellidos.txt | sort -k2 | uniq -f1 -t ' '

# Eliminar las lineas vacías de un texto.
sed 's/^$//g' #fichero

# Extraer hora y minuto de la fecha: 11:26
date +"%H:%M"

# Formatear la fecha con la forma: abr 11, 2013
date +"%h %d, %Y"
