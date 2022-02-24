#!/bin/bash
# Haz un script que muestre todos los usuarios de un sistema, leyendo /etc/passwd, cuyo shell por defecto sea bash
#
grep '/bin/bash' /etc/passwd | awk -F ':' '{print $1}'