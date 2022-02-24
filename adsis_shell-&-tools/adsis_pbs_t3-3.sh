#!/bin/bash
# En cierta asignatura, los estudiantes deben realizar una página web. Todos los matriculados tienen cuenta en la máquina, aunque 
# algunos nunca han llegado a abrir una sesión. A estos los llamaremos usuarios inactivos. Se desea hacer un script bash que haga una 
# copia de la web de todos los usuarios activos, que borre la cuenta de los usuarios inactivos y que muestre un pequeño informe de lo 
# que está haciendo. Los requisitos se detallan a continuación:
# 
# 1. Los usuarios matriculados tienen su home en el directorio al-03-04. Este es un fragmento del fichero /etc/passwd:
# 
# jperez:x:10912:1009:Juan Perez,,,:/home/al-03-04/jperez:/bin/bash
# mfernan:x:10913:1009:Manuel Fernandez,,,:/home/al-02-03/mfernan:/bin/bash
# mgarcia:x:10914:1009:Maria Garcia ,,,:/home/al-03-04/mgarcia:/bin/bash
# lruiz:x:10915:1009:Luis Ruiz ,,,:/home/al-03-04/lruiz:/bin/bash
# 
# 2. Si un usuario es inactivo, el comando finger indicará "Never logged in". Ejemplo:
# 
# $ finger jperez
# Login: jperez Name: Juan Perez
# Directory: /home/al-03-04/jperez Shell: /bin/bash
# Never logged in.
# No mail.
# No Plan.
# 
# 3. Las copias de las páginas web queremos guardarlas en /var/tmp/mgarcia y /var/tmp/lruiz. Estos directorios no existen previamente.
# 
# 4. Para hacer una copia de un web, usamos el comando wget del siguiente modo 
# wget -m http://localhost/~mgarcia -- esto copia el web de mgarcia en el directorio actual
# 
# 5. El informe que muestra el programa debe ser parecido a este:
# 
# jperez. Usuario inactivo, se borra su cuenta
# mgarcia. Usuario activo, copiando su web en /var/tmp/mgarcia
# lruiz. Usuario activo, copiando su web en /var/tmp/lruiz

# if [ ! -d /etc/usr_bck ]; then mkdir /etc/usr_bck; fi
alumnos=$(grep 'al-03-04' $1 | awk -F ':' '{print $1}')
for i in $alumnos
do
    if [ "$(finger $i 2>/dev/null | awk 'NR==3')"  == "Never logged in." ]
    then
        # tar -cvzf $(eval echo "~$i") /etc/usr_bck/${i}.tar.gz
        # userdel -f $i
        echo "${i}. Usuario inactivo, se borra su cuenta"
    else
        usr_dir=/var/tmp/$i
        # if [ ! -d $usr_dir ]; then mkdir $usr_dir; fi
        # curr_dir=$(pwd)
        # cd $usr_dir
        # wget -m http://localhost/~${i}
        echo "${i}. Usuario activo, copiando su web en $usr_dir"
    fi
done
