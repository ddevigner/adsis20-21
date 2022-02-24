#!/bin/bash
# ¿Cuál es el objetivo del siguiente script? Ejecutar script hasta que el numero generado sea igual a 9.
FRANCES=10
ALLEN=9
# $RANDOM is an internal Bash function (not a constant) that returns a
# pseudorandom [1] integer in the range 0 - 32767. It should not be used
# to generate an encryption key.
i=$(($RANDOM % $FRANCES)) # Generate a random number between 0 and $FRANCES - 1.
if [ "$i" -lt "$ALLEN" ]
then
    echo "i = $i"
    ./$0
fi
exit 0
