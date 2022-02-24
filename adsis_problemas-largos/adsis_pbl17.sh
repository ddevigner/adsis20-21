#!/bin/bash
# Escribe por favor un script que busque los sistemas de ficheros montados en un sistema que no se monten de manera automática al arrancar. Al terminar la búsqueda, 
# si se ha encontrado algún elemento, el script enviará un e-mail al usuario root con asunto “nuevos puntos de montaje” cuyo contenido será una lista con el dispositivo 
# de bloque y su punto de montaje correspondiente por linea. El dispositivo y el punto de montaje estarán separados por coma. Además, indica exactamente como ejecutar 
# el script de manera automática cada 20 minutos.
# Notas:
#     • En la busqueda deberán excluirse los siguientes pseudo-sistemas de ficheros: sysfs, tmpfs, securityfs, debugfs y proc.
#     • Ejemplo de fichero /etc/fstab:
#         "UUID=478096b2-dfa9-45bb-902e-9c22797665f0 / ext4 errors=remount-ro 0 0"
#         "/dev/sr0 /media/cdrom0 udf,iso9660 user,noauto 0 0"
#     • Ejemplo de fichero /etc/mtab:
#         "sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0"
#         "/dev/sda1 / ext4 rw,relatime,errors=remount-ro 0 0"
# 
# crontab -e
# PATH=...
# */20 * * * * ${PATH}/script.sh 
awk '/noauto/ {printf "%s, %s", $1, $2}' /etc/fstab /etc/mtab | grep -Ev '(sysfs|tmpfs|securityfs|debugfs|proc)' | sort | uniq | mail -s "nuevos puntos de montaje" root