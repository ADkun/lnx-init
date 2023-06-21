#!/bin/bash

function get_path {
    script_path="$(cd "$(dirname "$0")"; pwd)"
    script_name=$(basename "$0")
}
get_path

function main {
    "$script_path/uninstall.sh" "$@"
    "$script_path/install.sh" "$@"
}
main "$@"