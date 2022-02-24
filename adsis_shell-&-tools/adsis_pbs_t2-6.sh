#!/bin/bash
# Hacer un shell script con funciones matemáticas, debe tener un factorial calculado de forma iterativa, un factorial 
# calculado de forma recursiva, y una función que imprima la serie de fibonacci.
log(){
    echo -e "\nusage: ./shell_tools_2.6.sh <function> <number_target>\n"
    echo -e "\t<function>\t\t0. Iterative x!\n\t\t\t\t1. Recursive x!\n\t\t\t\t2. Fibonacci Series"
    echo -e "\t<number_target>\t\tx to calculate.\n"
    exit $1
}

factorial_iterativo() {
    f=$1
    for ((i=$(($1-1)); i>=1; i--))
    do
        f=$(($f*$i))
    done
    echo $f
}

factorial_recursivo(){
    if [ $1 -le 1 ]; then echo 1
    else echo $(($1 * $(factorial_recursivo $(($1 - 1)))))
    fi
}

fibonacci_iterativo(){
    p=0;
    s=1;
    fib=0;
    for ((i=0; i<$1; i++))
    do
        fib=$((p+s))
        p=$s
        s=$fib
    done
    echo $fib
}


if [ $# -ne 2 ]; then echo "error -- too few arguemnts."; log 1; fi
if [ $1 -lt 0 -o $1 -gt 2 ]; then echo "error -- unknown option, don't you think?"; log 1; fi
if [ $2 -lt 0 ]; then echo "error -- negative x?"; log 1; fi
f=0;
case $1 in
0) factorial_iterativo $2 ;;
1) factorial_recursivo $2 ;;
2) fibonacci_iterativo $2 ;;
esac
