#!/bin/bash
# Crear un script que, a partir de una especificación obtenida por entrada estándar, pueda crear o extender los volúmenes lógicos y sistemas de ficheros que residan 
# en dichos volúmenes.
#     • Cuando los volúmenes lógicos sean nuevos (no existan), el script añadirá el volumen lógico al fichero /etc/fstab para su correcto montaje en cada arranque del
#       sistema. El resto de los campos para fstab podrán serán idénticos a los valores de otras líneas con volúmenes lógicos. 
#     • Cuando los volumenes logicos existan, se extenderan, si procede.
# El script recibirá la especificación mediante líneas del siguiente formato:
#     "nombreGrupoVolumen,nombreVolumenLogico,tamaño,tipoSistemaFicheros,directorioMontaje"
# 
# Especificaciones:
# ${s[0]} = nombreGrupoVolumen
# ${s[1]} = nombreVolumenLogico
# ${s[2]} = tamaño
# ${s[3]} = tipoSistemaFicheros
# ${s[4]} = directorioMontaje

# ERROR LOG MESSAGE:
if [ $EUID -ne 0 ]; then 
    printf "\nerror -- unos permisos de administrador no vendrian mal, pleeeease.\n"
    printf "\nusage: sudo ./practica_5_parte3_lv.sh < vg_file\n\n"
    exit 1
fi
#read input;
while IFS= read -r input 
do
    IFS=, ; read -ra s <<< "$input"
    vdir=$(lvdisplay "${s[0]}/${s[1]}" -Co "lv_path" | grep "${s[0]}/${s[1]}" | tr -d '[[:space:]]') &> /dev/null
    if [ ! -z "$vdir" ]
    then
        echo "El volumen introducido ya existe, se procedera a la ampliacion del mismo."
        lvextend -L${s[2]} $vdir && resize2fs $vdir # El tamaño de extension debe ser mayor o igual al tamaño del disco a extender.
    else
        echo "El volumen introducido \"${s[1]}\" no existe, por lo que se procedera a su creacion..."
        lvcreate -L${s[2]} -n ${s[1]} ${s[0]}
        if [ $? -eq 0 ]
        then
            mkdir -p "${s[4]}"
            vdir=$(lvdisplay "${s[0]}/${s[1]}" -Co "lv_path" | grep "${s[0]}/${s[1]}" | tr -d '[[:space:]]')
            echo -e "$vdir\t${s[4]}\t${s[3]}\tdefaults 0 0" >> /etc/fstab
            mkfs.${s[3]} $vdir && mount $vdir ${s[4]}
        fi
    fi
    echo && echo
    unset s[@]
done
echo "By by! =D"
