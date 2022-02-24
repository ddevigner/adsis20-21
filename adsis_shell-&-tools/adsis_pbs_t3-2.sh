#!/bin/bash
# Tenemos un directorio que contiene, entre otras cosas, fotos: ficheros con extensión .jpg o .JPG. Las fotos tienen mucha resolución. 
# Queremos reducirlas a 800x600 puntos y publicar la versión reducida en una web. Para reducir el tamaño podemos usar el comando:
# 
# convert -geometry 800x600 origen destino
# 
# Para publicar en el web, basta copiar al directorio public_html del home del usuario. Suponemos este directorio existente y con 
# los permisos adecuados. Proceden de un sistema contaminado por un virus, así que hay ficheros que a pesar de su extensión, no son
# imágenes jpeg sino ejecutables. Si son verdaderas imágenes el comando "file" mostrará un mensaje similar a este:
# 
# imagen01.jpg: JPEG image data, EXIF standard 0.73, 10752 x 2048
# 
# Haz un script de shell bash que reciba como primer argumento el directorio, que compruebe cada fichero, que lo reduzca y publique 
# si está bien y que lo borre si está contaminado, mostrando un mensaje parecido a este:
# 
# imagen01.jpg CONTAMINADO. Se borra el fichero
# imagen02.jpg ok. Reducida y publicada
# imagen03.jpg ok. Reducida y publicada
# 1 ficheros contaminados y borrados
# 2 ficheros reducidos y publicados
c=0
t=0
for i in $(ls $1)
do
    type=$(file $i | awk -F '[:,]' '{print $2}' | sed 's/^[ ]*//')
    if [ "$type" != "JPEG image data" ] && [ "$type" != "PNG image data" ]
    then 
        echo "$i CONTAMINADO. Se borra el fichero"
        c=$(($c + 1))
        #rm $i
    else 
        echo "$i ok. Reducida y publicada"
        t=$(($t + 1))
        #convert -geometry 800x600 $i /$HOME/public_html
    fi
done

echo
echo "$c ficheros contaminados y borrados"
echo "$t ficheros reducidos y publicados"