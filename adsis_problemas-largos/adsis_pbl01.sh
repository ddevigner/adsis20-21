#!/bin/bash
# Un proceso zombie, estado Z, es un proceso que ha completado su ejecución pero que aún mantiene la entrada en el tabla de procesos. Ocurren cuando un proceso hijo 
# termina y el padre no ha ejecutado la correspondiente llamada a wait(). La unica manera de eliminar a un proceso zombie es matando al padre para que el proceso init 
# los adopte y ejecute el wait() correspondiente. Realiza un script que busque procesos zombies que lleven más de 24 horas en ejecución, puedes utilizar etimes de ps. 
# Para todos los procesos encontrados deberás enviar la señal KILL a su proceso padre y un mail al dueño del proceso para notificarle la defunción del mismo. Además al 
# terminar, el script deberá mandar un mail al administrador con la lista de todos los procesos matados con formato: pid, comando Además este proceso deberá ser 
# ejecutado cada 24 horas.
# 
kp=0
while read -r k u p c 
do
    if [ $k -eq 1 ]; 
    then 
        kill $p
        echo "Su proceso ha sido eliminado, una lastima." | mail -s "Matanza de procesos" as
        lista+=("${p}, ${c}")
        kp=$(($kp + 1))
    fi
    
done < <(ps -ostate,uid,ppid,etimes,cmd | sed '1d' | awk '
    {
        if($1 == "Z"){
            if($4/3600 >= 24){ printf "1 %s %s %s\n",$2,$3,$5 }
            else print 0
        }
        else print 0
    }')

if [ $kp -ne 0 ]; then printf '%s\n' "${lista[@]}" | mail -s "Procesos eliminados automaticamente" root; fi