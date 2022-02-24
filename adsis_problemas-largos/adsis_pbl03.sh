#!/bin/bash
# Se quiere monitorizar en tiempo real un servicio web con personas reales. Para facilitar su horario de trabajo, el servidor sólo aceptará peticiones en horario de 
# 9 a 2 y de 4 a 7 de lunes a viernes. Indica el mecanismo para implementar este comportamiento y escribe los comandos necesarios para ponerlo en marcha, incluyendo 
# algún script que fuera necesario. Se supondrá que el servidor web utilizado es apache y se podrá arrancar/apagar mediante los comandos service apache2 start/stop. 
# Cuando el servidor esté apagado también será necesario configurar un firewall para bloquear el tráfico al puerto 80 fuera de ese horario. El servidor web genera un 
# fichero de logs en el que aparece la IP, el puerto origen y la hora separados por espacios para cada una de las conexiones realizadas por los clientes. Realiza un 
# script que busque en el fichero las direcciones IP que se han intentado conectar desde la misma subred a la que esta conectada el interfaz eth0 del servidor para 
# posteriormente bloquear todo el tráfico proveniente de dichos nodos y enviar un email al usuario root de la máquina bloqueada para notificarle el bloqueo. El nombre 
# del fichero será el primer argumento en la invocación del script y si esté es invocado con un número incorrecto de argumentos devolverá un error.Nota: Se puede 
# asumir que la máscara de red del servidor es 255.255.0.0
# 
# PRIMERA PARTE
# crontab -e 
# 0  9 * * 1-5  /path/prl3.1.sh 1
# 0 14 * * 1-5  /path/prl3.1.sh 0
# 0 16 * * 1-5  /path/prl3.1.sh 1
# 0 19 * * 1-5  /path/prl3.1.sh 0
iptables -F
iptables -Z
iptables -X
iptables -t nat -F

if [ $1 -eq 1 ]
then
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -A INPUT --dport 80 -j ACCEPT
    service apache2 start
elif [ $1 -eq 0 ]
then
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -A INPUT --dport 80 -j DROP
    service apache2 stop
fi



# SEGUNDA PARTE
subnet() {
    OLDIFS=$IFS
    IFS='.'
    read -ra ip_fields <<< $1
    read -ra mask_fields <<< $2
    IFS=$OLDIFS
    for i in ${!ip_fields[@]}
    do
        subnet_addr=${subnet_addr}$((${ip_fields[$i]} & ${mask_fields[$i]}))"."
    done
    subnet_addr=$(echo $subnet_addr | sed 's/.$//' )
    echo $subnet_addr;

}

eth0_ip=$(ip -4 address show enp0s8 | sed '1d' | grep -o 'inet [0-9.]*' | cut -d' ' -f2)
eth0_subnet=$(subnet $eth0_ip 255.255.0.0)
while read -r connection
do
    connection_subnet=$(subnet $connection 255.255.0.0)
    if [ "$connection_subnet" == "$eth0_subnet" ]
    then
        connections=($connection)
        iptables -A INPUT -s $(echo $connection | cut -d' ' -f1) -j DROP
    fi
done < $1
printf "%s\n",${connections[@]} | mail -s "Hosts bloqueados." root