#!/bin/bash

__OpenSCAD_Path='/cygdrive/c/Program Files/OpenSCAD/openscad.exe'

__increment_width='0.5'
__max_width='6.0'

__sizes_width="$(seq "${__increment_width}" "${__increment_width}" "${__max_width}")"

__rootDirTarget='STL_OpenSCAD'

__OpenSCAD_File='Lid.scad'

if ! [ -d "${__rootDirTarget}" ]; then
    mkdir "${__rootDirTarget}"
fi

while read -r __width_larger; do

    while read -r __width_smaller; do

        if [ "$(bc -l <<<"${__width_larger} >= ${__width_smaller}")" = 1 ]; then

            __target_file="${__rootDirTarget}/Container_Lid_${__width_larger}x${__width_smaller}.STL"

            if ! [ -e "${__target_file}" ]; then

                "${__OpenSCAD_Path}" "${__OpenSCAD_File}" -o "${__target_file}" -D "width=${__width_larger}" -D "height=${__width_smaller}"

            fi

        fi

    done <<<"${__sizes_width}"

done <<<"${__sizes_width}"

exit
