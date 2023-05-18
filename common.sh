#!/bin/bash

SetPrinter(){
    SetRed="echo -en \e[91m"
    SetGreen="echo -en \e[32m"
    SetYellow="echo -en \e[33m"
    SetBlue="echo -en \e[36m"
    UnsetColor="echo -en \e[0m"
    Print(){
        echo -e "${1}"
    }
    PrintRed(){
        $SetRed
        echo -e "${1}"
        $UnsetColor
    }
    PrintYellow(){
        $SetYellow
        echo -e "${1}"
        $UnsetColor
    }
    PrintGreen(){
        $SetGreen
        echo -e "${1}"
        $UnsetColor
    }
    PrintBlue(){
        $SetBlue
        echo -e "${1}"
        $UnsetColor
    }
}
SetPrinter

ParseParam() {
    local arg;arg=
    for arg in "$@"; do
        val=$(echo "${arg}" | sed -e "s;--[^=]*=;;")

        case "${arg}" in
        -u) 
            USERMODE=true
            ;;
        *)
            echo "Unexpected arg: ${arg}, value: ${val}"
            ;;
        esac
    done
}
ParseParam "$@"

HandleParam() {
    if [ "$USERMODE" = "true" ]; then
        BASHRC_PATH=$HOME/.bashrc
        VIMRC_PATH=$HOME/.vimrc
        INPUTRC_PATH=$HOME/.inputrc
    else
        BASHRC_PATH=/etc/bashrc
        VIMRC_PATH=/etc/vimrc
        INPUTRC_PATH=/etc/inputrc
    fi


    if [ "$USERMODE" = "true" ]; then
        BIN_PATH=$HOME/.local/bin
        if [ ! -d "$BIN_PATH" ]; then
            mkdir -p "$BIN_PATH"
        fi
    else
        BIN_PATH=/usr/local/bin
    fi
}
HandleParam

GetArchitecture() {
    if uname -a | grep x86_64 >/dev/null 2>&1; then
        is_x64=true
        PrintGreen "Is x64"
    fi

    if uname -a | grep -E 'arm|aarch' >/dev/null 2>&1; then
        is_arm=true
        PrintGreen "Is arm"
    fi
}
GetArchitecture