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

InstallZoxide() {
    if [ -f "/usr/local/bin/zoxide" ]; then
        return 0
    fi

    if [[ ${is_arm} == true ]]; then
        if sudo cp -rf ./zoxide/aarch64/* /usr/local/bin/; then
            zoxide_installed=true
        fi
    elif [[ ${is_x64} == true ]]; then
        if sudo cp -rf ./zoxide/x64/* /usr/local/bin/; then
            zoxide_installed=true
        fi
    fi

    if [ "$zoxide_installed" = "true" ]; then
        sudo chmod u+x /usr/local/bin/zoxide
        PrintGreen "zoxide installed"
    fi
}

InstallAg() {
    if [ -f "/usr/local/bin/ag" ]; then
        return 0
    fi

    if [ -f "/usr/bin/ag" ]; then
        return 0
    fi

    if [ "$is_x64" = "true" ]; then
        if sudo cp -f ./silver/x64/ag /usr/local/bin/; then
            ag_installed=true
        fi
    fi

    if [ "$ag_installed" = "true" ]; then
        PrintGreen "Install ag succeed"
    fi
}

ConfigureVimrc() {
    if which vim >/dev/null 2>&1 && ! cat /etc/vimrc | grep pastetoggle >/dev/null 2>&1; then
        echo "" >> /etc/vimrc
        cat ./vimrc >> /etc/vimrc
        PrintGreen "/etc/vimrc wroted"
    fi
}

ConfigureBashrc() {
    if ! cat /etc/bashrc | grep SetPrinter >/dev/null 2>&1; then
        echo "" >> /etc/bashrc
        cat ./bashrc >> /etc/bashrc
        PrintGreen "/etc/bashrc wroted"
    fi

    if [ "$zoxide_installed" = "true" ]; then
        if ! cat /etc/bashrc | grep "zoxide init" >/dev/null 2>&1; then
            echo "" >> /etc/bashrc
            echo 'eval "$(zoxide init bash)"' >> /etc/bashrc
            PrintGreen "/etc/bashrc zoxide init wroted"
        fi
    fi

    if [ "$ag_installed" = "true" ]; then
        if ! cat /etc/bashrc | grep "alias agl" >/dev/null 2>&1; then
            echo "" >> /etc/bashrc
            echo "alias agl='ag -l '" >> /etc/bashrc
            PrintGreen "/etc/bashrc agl wroted"
        fi
    fi
}

ConfigureInputrc() {
    if ! cat /etc/inputrc | grep "completion-ignore-case" >/dev/null 2>&1; then
        echo "" >> /etc/inputrc
        cat ./inputrc >> /etc/inputrc
        PrintGreen "/etc/inputrc wroted"
    fi
}

ConfigureFiles() {
    ConfigureVimrc
    ConfigureBashrc
    ConfigureInputrc
}

Main() {
    GetArchitecture
    InstallZoxide
    InstallAg
    ConfigureFiles
}
Main
