#!/bin/bash
# Hacer un shell script que dado un fichero de texto, cuente las cinco palabras más repetidas
tr -c '[:alnum:]' '[\n*]' < $1 | sort | uniq -c | sort -nr | head  -6