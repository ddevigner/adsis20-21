#!/bin/bash
# El siguiente script intenta buscar los ficheros que cumplen un patrón, tienen la extensión .txt, para escribirlos por pantalla 
# pero presenta varios fallos. ¿Podrías indicar cómo solucionarlos?
#
re='\.txt$'
for file in ./*
do
    if [[ $file =~ $re ]] #<--- ERROR: Original: if [ $file =~ "$re" ]
    then
        echo "Match found: $file"
    fi
done