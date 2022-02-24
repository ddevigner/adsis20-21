#!/bin/bash
# Implementa un script para cambiar el password de un usuario verificando que su longitud es de al menos 8 caracteres, que tenga letras 
# mayúsculas y minúsculas y dígitos. ¿Dispone linux de algún mecanismo mejor para hacer esta comprobación?
#
read password;
if [ ! ${#password} -ge 8 ]; then echo "password de, o mas de, 8 caracteres, por favor."; exit 1; fi
echo $password | grep -qe [[:upper:]]
if [ $? -ne 0 ]; then echo "al menos, una mayuscula."; fi 
echo $password | grep -qe [[:lower:]]
if [ $? -ne 0 ]; then echo "al menos, una minuscula."; fi
echo $password | grep -qe [[:digit:]]
if [ $? -ne 0 ]; then echo "al menos, un digito."; fi 
echo "${1}:${password}" | chpasswd