#!/bin/bash
# Empleando el pseudo-sistema de ficheros /proc se desea obtener un script que muestre una lista de procesos que contenga la siguiente información:
#     "id proceso, nombre, memoria_residente_proceso_e_hijos"
# La lista contendrá únicamente procesos que sean hijos del proceso init, ID 1, y el cálculo de la memoria residente se hará sumando a la memoria residente del proceso 
# la memoria residente consumida por sus hijos, nietos de init. La lista será visualizada al final de la ejecución y estará ordenada por el tamaño de memoria residente 
# como se ve a continuación:
#     "805, lightdm, 63052 KB"
#     "906, tmux: server, 21544 KB"
#     "846, systemd, 18292 KB"
#     "408, sshd, 12660 KB"
#     "853, at-spi-bus-laun, 9444 KB"
#     "882, systemd, 8200 KB"
#     "862, at-spi2-registr, 6892 KB"
#     "340, systemd-logind, 4828 KB"
#     "167, systemd-journal, 4660 KB"
#     "347, dbus-daemon, 4028 KB"
#     "188, systemd-udevd, 3952 KB"
#     "344, rsyslogd, 3304 KB"
#     "820, VBoxService, 3064 KB"
# /proc contiene un directorio por proceso con nombre /proc/<pid> siendo <pid> el identificador del proceso. Para la generación de la lista se puede consultar el 
# fichero /proc/<pid>/status correspondiente al proceso con id <pid> y que tiene el siguiente formato (campos separados por uno o varios espacios):
#     "Name: exim4"
#     "Umask: 0000"
#     "State: S (sleeping)"
#     "Pid: 745"
#     "PPid: 1"
#     "VmSize: 56152 kB"
#     "VmLck: 0 kB"
#     "VmPin: 0 kB"
#     "VmHWM: 2588 kB"
#     "VmRSS: 2588 kB"
# Una vez obtenida la lista, el script deberá cambiar la prioridad de ejecución a +15 para los 4 procesos que entre ellos y sus hijos consuman más memoria. Para 
# evitar problemas con la creación y/o terminación de procesos, el script deberá guardar al principio de su ejecución el estado de todos los procesos.
# 
# Nota: Se puede asumir que el script se ejecuta con privilegios de administración y que al cambiar la prioridad el proceso sigue vivo. La opción -s del comando tr 
# reemplaza múltiples ocurrencias de un carácter repetido por una única ocurrencia.
# 
children(){
    for p in "$@"
    do  
        a=$(ps -e -oppid,pid | sed 's/^[ ]*//' | grep "^$p" | tr -s ' ' | cut -d' ' -f2)
        if [ -z "${a[@]}" ]; then echo "$p"
        else children ${a[@]}; fi
    done
}

a=$(while read -r pid
do
    cat /proc/${pid}/status 2>/dev/null | awk -v "p=$pid" '
        /Name/ {n=$2}
        /State/ {s=$2}
        /VmSize|VmLck|VmPin|VmHWM|VmRSS/ {m+=$2} 
        END {if(s!=null && m!=null) printf "%d, %s, %d KB, %s\n",p,n,m,s}
        '
done < <(children 1) | sort -nr -t ',' -k3)

while read -r cmd
do
    nice -n+15 $cmd
done < <(echo "${a[@]}" | head -n 4 | cut -d',' -f2 | sed 's/ //')
echo "${a[@]}" | cut -d',' -f1,2,3
