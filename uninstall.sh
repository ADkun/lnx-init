#!/bin/bash

function get_path {
    script_path="$(cd "$(dirname "$0")"; pwd)"
    script_name=$(basename "$0")
}
get_path

. "$script_path/common.sh"

function Uninstall {
    if sed -i '/### AD ###/,/### AD ###/d' "$BASHRC_PATH"; then
        PrintGreen "Uninstall $BASHRC_PATH succeed"
    fi

    if sed -i '/### AD ###/,/### AD ###/d' "$INPUTRC_PATH"; then
        PrintGreen "Uninstall $INPUTRC_PATH succeed"
    fi

    if sed -i '/""" AD """/,/""" AD """/d' "$VIMRC_PATH"; then
        PrintGreen "Uninstall $VIMRC_PATH succeed"
    fi

    if [ -f $BIN_PATH/zoxide ]; then
        if rm -f $BIN_PATH/zoxide; then
            PrintGreen "Uninstall $BIN_PATH/zoxide succeed"
        fi
    fi
    if sed -i '/zoxide init bash/d' "$BASHRC_PATH"; then
        PrintGreen "Uninstall $BASHRC_PATH zoxide succeed"
    fi

    if [ -f $BIN_PATH/ag ]; then
        if rm -f $BIN_PATH/ag; then
            PrintGreen "Uninstall $BIN_PATH/ag succeed"
        fi
    fi
    if sed -i '/alias agl/d' "$BASHRC_PATH"; then
        PrintGreen "Uninstall $BASHRC_PATH ag succeed"
    fi
}

function Main {
    Uninstall
}
Main