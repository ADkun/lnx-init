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

function Uninstall {
    if sed -i '/### AD ###/,/### AD ###/d' /etc/bashrc; then
        PrintGreen "Uninstall /etc/bashrc succeed"
    fi

    if sed -i '/### AD ###/,/### AD ###/d' /etc/inputrc; then
        PrintGreen "Uninstall /etc/inputrc succeed"
    fi

    if sed -i '/""" AD """/,/""" AD """/d' /etc/vimrc; then
        PrintGreen "Uninstall /etc/vimrc succeed"
    fi

    if [ -f /usr/local/bin/zoxide ]; then
        if rm -f /usr/local/bin/zoxide; then
            PrintGreen "Uninstall /usr/local/bin/zoxide succeed"
        fi
    fi
    if sed -i '/zoxide init bash/d' /etc/bashrc; then
        PrintGreen "Uninstall /etc/bashrc zoxide succeed"
    fi

    if [ -f /usr/local/bin/ag ]; then
        if rm -f /usr/local/bin/ag; then
            PrintGreen "Uninstall /usr/local/bin/ag succeed"
        fi
    fi
    if sed -i '/alias agl/d' /etc/bashrc; then
        PrintGreen "Uninstall /etc/bashrc ag succeed"
    fi
}

function Main {
    Uninstall
}
Main