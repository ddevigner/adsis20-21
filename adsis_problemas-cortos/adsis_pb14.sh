#!/bin/bash
# Indica en qué casos este siguiente comando podría fallar y como solucionarlo.
# 1. source_file no existe o es inaccesible.
# 2. destination_file no existe como directorio o es inaccesible.
# 3. al cambiarlo de nombre, ya existe un archivo con el nombre destination_file.
# 4. el acceso a source_file esta restringido.
# 5. el acceso a destination_file esta restringido.
# 6. al cambiarlo de directorio, ya existe un archivo con el nombre source_file.
# 7. source_file y destination_file son la misma y ambas son directorios.
#
mv $source_file $destination_file