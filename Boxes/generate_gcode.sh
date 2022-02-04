#!/bin/bash

__rootDirSource='STL_OpenSCAD'

__rootDirTarget='gcode_Cura'

__CuraVersion='4.5'

__CuraPath="/cygdrive/c/Program Files/Ultimaker Cura ${__CuraVersion}"

__CuraEngine="${__CuraPath}/CuraEngine.exe"

__CuraMachineDefinition="machine.def.json"

__CuraEngineArgumentsFile='CuraEngineSettings.txt'

if ! [ -d "${__rootDirTarget}" ]; then
    mkdir "${__rootDirTarget}"
fi
set -x

find "${__rootDirSource}" -maxdepth 1 -type f -iname '*.STL' | while read -r __file; do
    __target_file="${__rootDirTarget}/$(basename -s '.STL' "${__file}")"
    if ! [ -e "${__target_file}" ]; then
        
        xargs -t -a "${__CuraEngineArgumentsFile}" "${__CuraEngine}" slice -l "${__file}" -o "${__target_file}"
        set +x
        exit
    fi
done

exit
