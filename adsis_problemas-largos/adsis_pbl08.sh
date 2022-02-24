#!/bin/bash
# Dada la subred 172.16.0.0/24 se desea asegurar que todos los nodos de dicha subred comparten el mismo fichero de nombres, /etc/hosts. Para ello, se plantea una 
# solución con 2 scripts. El primero que se encargará de acceder a todas las máquinas, mezclará los ficheros /etc/hosts para que no haya ninguna IP repetida, copiará 
# el fichero resultante en todos los nodos y relanzará el servicio de red, y el segundo que comprobará todos los días a las 3.14 horas que todos los nodos comparten 
# el mismo fichero /etc/hosts que 172.16.0.1. Al terminar la comprobación, se deberá enviar un mail al usuario root con la lista de los nodos, una IP por línea, para 
# los que el fichero sea distinto, si hubiera alguno. El motivo del mensaje será lista nodos. Nota: Se puede asumir que sólo se emplearán direcciones IPv4, que si hay 
# direcciones IP repetidas apuntarán al mismo nombre y que todos los nodos de la red están vivos. El usuario user tiene acceso vía ssh con clave sin password en todas 
# las máquinas de la subred y privilegios de administración mediante sudo.
# 
# PRIMERA PARTE
subred() {
    OLDIFS=$IFS
    IFS=.
    read -ra ip <<< "$1"
    read -ra mask <<< "$2"
    for ((i=0; i<"${#ip[@]}"; i++)); do
        subnet=${subnet}$((${ip[$i]} & ${mask[$i]}))"."
    done
    IFS=$OLDIFS
    subnet=$(echo $subnet | sed 's/.$//')
    echo $subnet
}

sn=$(subred 172.16.0.0 255.255.255.0)
nodes=$(ip n | cut -d' ' -f1)

for i in "${nodes[@]}"; do
    if [ "$(subred $node 255.255.255.0)" == "$sn" ]; then
        ssh -nf user@$i 'cat /etc/hosts'
    fi
done | grep -E '([0-9{1,3}])[.]([0-9{1,3}])[.]([0-9{1,3}])[.]([0-9{1,3}])' | \
    sort -u -k1,1 > /tmp/hosts.tmp

for i in ${nodes[@]}; do
    cat /tmp/hosts.tmp | ssh user@$i 'sudo cat > /etc/hosts && systemctl restart networking'
done
#sudo cat /tmp/host.tmp > /etc/hosts

# SEGUNDA PARTE
# crontab -e
# 14 3 * * * path_script/nombre_script.sh
subred() {
    OLDIFS=$IFS
    IFS=.
    read -ra ip <<< "$1"
    read -ra mask <<< "$2"
    for ((i=0; i<"${#ip[@]}"; i++)); do
        subnet=${subnet}$((${ip[$i]} & ${mask[$i]}))"."
    done
    IFS=$OLDIFS
    subnet=$(echo $subnet | sed 's/.$//')
    echo $subnet
}

sn=$(subred 172.16.0.0 255.255.255.0)
nodes=$(ip n | cut -d' ' -f1)

for i in "${nodes[@]}"; do
    if [ "$(subred $node 255.255.255.0)" == "$sn" ]; then
        ssh -nf user@$i 'cat /etc/hosts' | diff - /etc/hosts &>/dev/null
        if [ $? -eq 0 ]; then echo $node; fi
    fi
done | mail -s "lista nodos" root