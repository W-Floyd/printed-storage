#!/bin/bash

__STLdir='STL_OpenSCAD'
__gcodeDir='GCode'

__zero_strip() {

    cat | sed -e 's|\(\..*[^0]\)0\{1,\}$|\1|' -e 's|\.0*$||' -e 's|^0*||' -e 's|^\.|0.|' -e 's|^$|0|'

}

__target_sizes_function() {
    __increment_width='0.5'
    __max_width='4.0'

    __increment_height='1.0'
    __max_height='2.0'

    __sizes_width="$(seq "${__increment_width}" "${__increment_width}" "${__max_width}")"
    __sizes_height="$(seq "${__increment_height}" "${__increment_height}" "${__max_height}")"

    while read -r __width_larger; do

        while read -r __width_smaller; do

            if [ "$(bc -l <<<"${__width_larger} >= ${__width_smaller}")" = 1 ]; then

                while read -r __height; do

                    echo "${__width_larger}x${__width_smaller}x${__height}"

                done <<<"${__sizes_height}"

            fi

        done <<<"${__sizes_width}"

    done <<<"${__sizes_width}"

}

__target_sizes="$(__target_sizes_function)"

__list_STL_function() {
    find "${__STLdir}" -maxdepth 1 -type f -iname '*.STL' | sed 's/.*\/\(.*\)\.STL/\1/'
}

__list_STL="$(__list_STL_function)"

__list_gcode_function() {
    find "${__gcodeDir}" -maxdepth 1 -type f -iname '*.gcode' | sed 's/.*\/\(.*\)\.gcode/\1/'
}

__list_gcode="$(__list_gcode_function)"

__find_missing_STL() {
    grep -Fxv "${__list_STL}" <<<"${__target_sizes}"
}

__find_missing_gcode() {
    grep -Fxv "${__list_gcode}" <<<"${__list_STL}"
}

echo "Missing STL:
"

__find_missing_STL

echo "


Missing gcode:
"

__find_missing_gcode

exit
