#!/bin/bash

function get_path {
    script_path="$(cd "$(dirname "$0")"; pwd)"
    script_name=$(basename "$0")
}
get_path

. "$script_path/common.sh"

InstallZoxide() {
    if [ -f "$BIN_PATH/zoxide" ]; then
        zoxide_installed=true
        return 0
    fi

    if [[ ${is_arm} == true ]]; then
        if cp -rf ./zoxide/aarch64/* "$BIN_PATH"; then
            zoxide_installed=true
        fi
    elif [[ ${is_x64} == true ]]; then
        if cp -rf ./zoxide/x64/* "$BIN_PATH"; then
            zoxide_installed=true
        fi
    fi

    if [ "$zoxide_installed" = "true" ]; then
        chmod u+x "$BIN_PATH/zoxide"
        PrintGreen "zoxide installed"
    fi
}

InstallAg() {
    if [ -f "/usr/local/bin/ag" -o -f "/usr/bin/ag" -o -f "$HOME/.local/bin/ag" ]; then
        ag_installed=true
        return 0
    fi

    if [ "$is_x64" = "true" ]; then
        if cp -f ./silver/x64/ag "$BIN_PATH"; then
            ag_installed=true
        fi
    fi

    if [ "$ag_installed" = "true" ]; then
        PrintGreen "Install ag succeed"
    fi
}

ConfigureVimrc() {
    if which vim >/dev/null 2>&1 && ! cat "$VIMRC_PATH" | grep '""" AD """' >/dev/null 2>&1; then
        echo "" >> "$VIMRC_PATH"
        cat ./vimrc >> "$VIMRC_PATH"
        PrintGreen "$VIMRC_PATH wroted"
    fi
}

ConfigureBashrc() {
    if ! cat "$BASHRC_PATH" | grep "### AD ###" >/dev/null 2>&1; then
        echo "" >> "$BASHRC_PATH"
        cat ./bashrc >> "$BASHRC_PATH"
        PrintGreen "$BASHRC_PATH wroted"
    fi

    if [ "$USERMODE" = "true" ]; then
        if ! cat "$BASHRC_PATH" | grep "PATH=$BIN_PATH" >/dev/null 2>&1; then
            echo "" >> "$BASHRC_PATH"
            echo "PATH=$BIN_PATH:$PATH" >> "$BASHRC_PATH"
        fi
    fi

    if [ "$zoxide_installed" = "true" ]; then
        if ! cat "$BASHRC_PATH" | grep "zoxide init" >/dev/null 2>&1; then
            echo "" >> "$BASHRC_PATH"
            echo 'eval "$(zoxide init bash)"' >> "$BASHRC_PATH"
            PrintGreen "$BASHRC_PATH zoxide init wroted"
        fi
    fi

    if [ "$ag_installed" = "true" ]; then
        if ! cat "$BASHRC_PATH" | grep "alias agl" >/dev/null 2>&1; then
            echo "" >> "$BASHRC_PATH"
            echo "alias agl='ag -l '" >> "$BASHRC_PATH"
            PrintGreen "$BASHRC_PATH agl wroted"
        fi
    fi
}

ConfigureInputrc() {
    if ! cat "$INPUTRC_PATH" | grep "### AD ###" >/dev/null 2>&1; then
        echo "" >> "$INPUTRC_PATH"
        cat ./inputrc >> "$INPUTRC_PATH"
        PrintGreen "$INPUTRC_PATH wroted"
    fi
}

ConfigureFiles() {
    ConfigureVimrc
    ConfigureBashrc
    ConfigureInputrc
}

Main() {
    InstallZoxide
    InstallAg
    ConfigureFiles
}
Main
