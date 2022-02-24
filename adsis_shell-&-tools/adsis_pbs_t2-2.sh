#!/bin/bash
# Un profesor tiene las notas de los alumnos que se presentaron a un examen en un fichero de texto. Cada línea está compuesta por el nombre y apellido del
# alumno, un espacio y su calificación, que siempre será apto o no apto. Desea que para cada línea del texto se genere lo siguiente:
# 
# mailto: direccion@unizar.es body: nombre apellido nota. Presentados: n, aprobados: m
if [ $# -ne 1 ]; then echo -e "\nusage: ./shell_tools_2.1.sh <file>\n"; exit 1; fi
awk ' BEGIN{ap=0}
    { 
      mail=tolower(substr($1,0,2) $2 "@unizar.es"); if ($3 >= 5) ap++;
      printf "mailto: %s body: %s %s %d. Presentados: %d, aprobados: %d\n",mail,$1,$2,$3,NR,ap
    }' $1
