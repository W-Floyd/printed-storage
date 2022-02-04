#!/bin/bash

__rootDirSource='gcode_Cura'
__rootDirTarget='GCodeOrganized'

if [ -d "${__rootDirTarget}" ]; then
    rm -r "${__rootDirTarget}"
fi

find "${__rootDirSource}" -maxdepth 1 -type f -iname '*.gcode' | while read -r __file; do
    __target="${__rootDirTarget}/$(sed -e 's/.*_\(.*\)x\(.*\)x\(.*\)\..*/\1\/\2\/\1x\2x\3.gcode/' <<<"${__file}")"
    __target_dir="$(dirname "${__target}")"
    if ! [ -d "${__target_dir}" ]; then
        mkdir -p "${__target_dir}"
    fi
    cp "${__file}" "${__target}"
done

exit