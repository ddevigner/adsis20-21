#!/bin/bash
# Realiza un script en bash que reciba como argumento uno o varios enlaces a páginas web y cuente el número de enlaces seguros, https, 
# que contenga cada una de las páginas. Para la cuenta es suficiente contar el número de veces que aparezca la cadena https en el 
# fichero. El script devolverá un error si es llamado sin ningún argumento. Cuando la ejecución sea correcta, la salida del script 
# contendrá una linea por página web procesada y cada linea estará formada por el nombre de la web y el número de enlaces seguros.
#
for url in "$@"; do
    TMPFILE=$(mktemp /tmp/webpage.XXXXXX)
    wget -O $TMPFILE $url &>/dev/null
    total_links=$(sed 's/https/https\n/g' $TMPFILE | grep -c https)
    echo "$url: links seguros: $total_links"
    rm -rf $TMPFILE
done