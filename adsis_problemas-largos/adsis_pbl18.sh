#!/bin/bash
# Escribe por favor el script “zmore.sh”. Al igual que el comando more, zmore.sh lista el contenido de sus argumentos cuando estos son ficheros de texto. Además, 
# si alguno de los parámetros de entrada esta comprimido, es capaz de descomprimirlo al vuelo. Es decir, dado un fichero de entrada input.txt, la salida de: 
# more input.txt y de gzip input.txt; zmore.sh input.txt.gz será idéntica. Si alguno de los argumentos no es un fichero de texto ni esta comrpimido, el script
# mostrará el siguiente mensaje “<argumento>: Not a text file” y continuará procesando el resto de argumentos. En caso de no recibir argumentos, el código de salida 
# será 1 y no se mostrara nada por pantalla. 
#  
# Notas: 
#     • Zmore.sh únicamente soportara ficheros comprimidos con las siguientes extensiones: gz, bzip2 y xz.
#     • La salida del comando file para ficheros gz, bzip2 y xz es: 
#         $ file input.txt.gz Input.txt.gz: gzip compressed data 
#         $ file input.txt.bz2 Input.txt.gz: bzip2 compressed data 
#         $ file input.txt.xz Input.txt.gz: XZ compressed data
#     • Para ficheros de texto, la salida del comando file es: $ file input.txt Input.txt: ASCII text.
#     • Los comandos gunzip, bunzip2 y unxz permiten descomprimir ficheros gz, bzip2 y xz, respectivamente. 
#
if [ $# -eq 0 ]; then exit 1; fi
for txtfile in "$@"; do
    if [ -e $txtfile]; then
        filetype=$(file $txtfile | cut -d':' -f2 | sed 's/^.//')
        if (file $txtfile | grep -q 'gzip'); then gunzip -c $txtfile
        elif (file $txtfile | grep -q 'bzip2'); then bunzip2 -c $txtfile
        elif (file $txtfile | grep -q 'XZ'); then unxz -c $txtfile
        elif (file $txtfile | grep -q 'ASCII'); then more $txtfile
        else echo "${txtfile}: Not a text file"
        fi
    fi
done