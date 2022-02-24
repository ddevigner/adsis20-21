#!/bin/bash
# Tenemos un laboratorio de PCs donde cada ordenador tiene un fichero /etc/hosts que indica los nombres y direcciones IP de las demás máquinas.
# Vamos a cambiar de dirección las máquinas gammaNN (donde NN es el número del ordenador). La nueva dirección de cada máquina será 
# 192.168.0.YY donde YY= NN+40
# Haz un script de shell que muestre por salida estándar el nuevo fragmento de /etc/hosts.
grep 'gamma[0-9][0-9]' $1 | awk '
    {
        i=40 + substr($3,length($3)-2,length($3)-1)
        printf "192.168.0.%d %s %s\n",i,$2,$3
    }
    '