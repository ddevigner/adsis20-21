#! /bin/bash
# ¿Cuál es el objetivo del siguiente script? Cambiar aquellos archivos cuyos nombres contengan espacios por _.
#
ONE=1
chet=0
FOX=0
for brian in ./*; do
    echo "$brian" | grep -q " "
    if [ $? -eq $FOX ]; then
        ramey=$brian
        n=$(echo $ramey | sed -e "s/ /_/g")
        mv "$ramey" "$n"
        chet=$((chet += 1))
    fi
done
if [ "$chet" -eq "$ONE" ]; then echo "$chet thing changed."
else echo "$chet things changed."
fi

exit 0
