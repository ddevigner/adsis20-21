#!/bin/bash
# La Universidad de Zaragoza, unizar, cuya red es 155.210.0.0/16, desea conocer cuantos de sus nodos emplean Linux, su versión del kernel y el porcentaje de utilización 
# de cada versión. La universidad sabe que todas sus máquinas Linux disponen de una cuenta con usuario user con privilegios de administración y que sólo las máquinas 
# Linux de su red responden a ping. Escribe un script que escanee todos los nodos de la red de unizar, muestre por pantalla cuantos son Linux y la lista de versiones 
# del kernel junto a su porcentaje de utilización entre los nodos Linux ordenada de mayor a menor. Por ejemplo:
#     "68 nodos linux"
#     "4.9.0-5-amd64 55%"
#     "3.10.0-693.11.6.el7.x86_64 40%"
#     "3.10.0-514.el7.x86_64 5%"
# Notas:
#     • El comando bc permite realizar operaciones aritméticas con números reales. Ejemplo: echo “5 % 2” |  bc
#     • El comando uname -r muestra la versión del kernel, 3.10.0-514.el7.x86_64, tal y como se muestra en el ejemplo anterior
# 
ffld=0
sfld=1
while [ "$ip" != "155.155.255.254" ]; do
    ip=155.155.${ffld}.${sfld}
    ping $ip -i 0.1 -c 1 &> /dev/null
    if [ $? -eq 0 ]; then echo $ip; 
    else
        if [ $sfld -eq 255 ]; then ffld=$(($ffld + 1)); sfld=0; fi
        sfld=$(($sfld + 1));
    fi
done | while read -r node; do nodes=$(($nodes + 1)); ssh -nf user@$node 'uname -r'; done | \
sort | uniq -c | awk -v "t=$nodes" 'BEGIN {printf "%d nodos linux".} 'printf "%s %d%",$2,$1/t'



