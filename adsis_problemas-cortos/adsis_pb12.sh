#!/bin/bash
# Programa un script que cuente el número de nodos que son visitados para alcanzar la dirección www.google.com. Puedes utilizar 
# una herramienta como traceroute. Ademas de mostrar los nodos visitados, la salida de traceroute contiene el round-trip time, RTT, 
# de cada uno de los servidores visitados. Utiliza dichos valores de RTT para mostrar los 5 nodos con mayor RTT. Ya que traceroute
# devuelve el RTT para 3 paquetes, idealmente deberás hacer la media de los 3 paquetes para calcular el RTT medio de cada nodo. En caso 
# de que se produzcan time-outs con traceroute, lo que dificulta procesar su salida, puedes hacer que el script tome como argumento 
# la siguiente entrada
#
traceroute $1 | sed -E -e '1d' -e 's/([0-9]*[.][0-9]*)[ ]*[a-zA-Z]*/\1/g' | awk '{m=($3+$4+$5)/3; print $2" "m}' | \
sort -r -n -k2 | head -n5