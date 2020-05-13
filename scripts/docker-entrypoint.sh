#!/bin/bash

function get_solution_out_file {
    local solution="$(basename ${1})"
    local solution_dir="/tmp/${solution%*.sln}"
    mkdir -p "${solution_dir}"

    echo "${solution_dir}/inspect_$(date '+%Y%m%d_%H%M%S.xml')"
}

solutions=("$(find /inspections/ -name '*.sln')")
out_files=()
for solution in ${solutions}; do
    out_file="$(get_solution_out_file ${solution})"
    out_files+=("${out_file}")

    echo "Running resharper to \"${solution}\" out file: \"${out_file}\""
    /usr/bin/resharper "${solution}" --output="${out_file}"
done

for file in ${out_files[@]}; do
    echo "####################"
    echo "Results for: \"${file}\""
    if [ -f ${file} ]; then
        cat "${file}"
    else
        echo "    Not found."
    fi
done
