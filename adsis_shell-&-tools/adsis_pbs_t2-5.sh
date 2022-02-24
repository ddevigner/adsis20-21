#!/bin/bash
# Partiendo de esta utilidad realice un shell-script 'mi_banner.sh' que admita hasta tres argumentos de tamaño máximo 
# de cuatro caracteres tal que el comando './mi_banner.sh hola jose luis'
log() {
    echo -e "\nusage: ./shell_tools_2.5.sh <word> <word> <word>\n"
    echo -e "\t<word>\t\tWord to print as banner. Max length: 4.\n"
    exit 1
}
if [ $# -ne 3 ]; then echo "error -- too few parameters."; log; fi
if [ ${#1} -gt 4 ]; then echo "error -- incorrect first parameter length, max 4."; log; fi
if [ ${#2} -gt 4 ]; then echo "error -- incorrect second parameter length, max 4."; log; fi
if [ ${#3} -gt 4 ]; then echo "error -- incorrect third parameter length, max 4."; log; fi 
w1=$(echo $1 | tr [a-z] [A-Z])
w2=$(echo $2 | tr [a-z] [A-Z])
w3=$(echo $3 | tr [a-z] [A-Z])
figlet -f lean $w1 $w2 $w3 | sed -r 's/^[ ]*(_)/\1/'