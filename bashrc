### AD ###
# Colorful shell prompt
if [[ $- == *i* ]]; then
    PS1='\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\$'
fi
# Type folder path to cd into it withoud "cd"
shopt -s autocd

# Common Function: Print colorful words
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

function run_command {
    local command
    local result
    command="$@"
    eval "$command"
    result=$?
    if [ "$result" -eq 0 ]; then
        PrintGreen "[OK] $command"
        return 0 
    else
        PrintRed "[ERROR] $command"
        return "$result"
    fi
}


# Find all matched files' content in current folder(recursive)
# Note: [If already installed the silver searcher(ag), use "ag" and "agl" to replace these commands]
# fig: Case sensitive, show file names and matched lines
# figl: Case sensitive, show file names only
# figi: Case insensitive, show file names and matched lines
# figil: Case insensitive, show file names only
function fig {
    find . -type f | while read -r line; do res=$(grep -a "$1" "$line"); if [ -n "$res" ]; then PrintGreen "$line:"; Print "$res"; res=""; fi; done
}
function figl {
    find . -type f | while read -r line; do res=$(grep -a "$1" "$line"); if [ -n "$res" ]; then echo "$line:"; res=""; fi; done
}
function figi {
    find . -type f | while read -r line; do res=$(grep -ai "$1" "$line"); if [ -n "$res" ]; then PrintGreen "$line:"; Print "$res"; res=""; fi; done
}
function figil {
    find . -type f | while read -r line; do res=$(grep -ai "$1" "$line"); if [ -n "$res" ]; then echo "$line:"; res=""; fi; done
}

# cd to parent folders by using dots only
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# List matched processes
function pg {
    ps -ef | grep -v grep | grep -i "$1";
}
# grep processess and kill them
function pgk {
    local list
    local name
    name="$1"
    if [ -z "$name" ]; then
        PrintRed "Usage: pgk <process_name>"
        return 1
    fi

    list=$(pg "$name" | awk '{print $2}')
    while read -r line; do
        run_command "kill -TERM $line"
    done <<< "$list"
}

# Find all matched files in current folder(recursive)
function ff {
    find . -type f | grep -i "$1"
}
# Find all matched folders in current folder(recursive)
function fd {
    find . - type d | grep -i "$1"
}
# Find all matched files in current folder and 
function cdff {
    cd "$(dirname "$(ff "$1" | head -n "$2" | tail -n 1)")" || return
}

# locate grep
function lc {
    updatedb
    locate "$1"
}
function lg {
    lc "$1" | grep -i "$2"
}

# l is ll
alias ll="ls -l --color=auto"
alias l='ll'
# Grep matched ll result
function llg {
    ll | grep -i "$1"
}
# Grep matched ls result
function lsg {
    ls | grep -i "$1"
}

# Show matched strings in a specified file
function strg {
    strings "$1" | grep -i "$2"
}

# Clear a specified file
function wipef {
    if [ -f "$1" ]; then
        echo "" > "$1"
    fi
}

# systemctl
function ScDo {
    systemctl "$1" "$2"
}
# Enable a service
function sce {
    ScDo "enable" "$1"
}
# Disable a service
function scd {
    ScDo "disable" "$1"
}
# Start a service
function scs {
    ScDo "start" "$1"
}
# Restart a service
function scr {
    ScDo "restart" "$1"
}
# Stop a service
function sct {
    ScDo "stop" "$1"
}
# Show a service's status
function sca {
    ScDo "status" "$1"
}
# Show services list
alias sclist='systemctl list-units --type=service'

# git commands
alias gib='git branch'
alias gis='git status'
alias gips='git push'
alias gipl='git pull'
alias gicl='git clone'
alias gir='git remote'
alias gich='git checkout'
alias gia='git add'
alias gicm='git commit'
alias gil='git log'
alias gid='git diff'
alias gif='git fetch'
alias girm='git remote -v'

# Show what processes are in occupying the specified folders(recursive)
function lsofd {
    local arg;arg=
    for arg in "$@"; do
        local cur_dir="$arg"
        PrintBlue "$cur_dir"
        lsof +D "$cur_dir"
        echo ""
    done
}

# Show what processes are in occupying the specified ports
function lsofi {
    local arg;arg=
    for arg in "$@"; do
        local cur_port="$arg"
        PrintBlue "$cur_port"
        lsof -i:"$cur_port"
        echo ""
    done
}

# kill all processes that are in occupying specified folders(recursive)
function unlockd {
    local arg;arg=
    for arg in "$@"; do
        local cur_dir="$arg"
        if [ "$cur_dir" = "/" ]; then
            PrintRed "Don't do this"
            return 1
        fi
        PrintBlue "$cur_dir"
        result=$(lsof +D "$cur_dir")
        pids=$(echo "$result" | sed '1d' | awk '{print $2}')
        if echo "$pids" | xargs -I {} kill -TERM {}; then
            PrintGreen "Killed:"
            PrintGreen "$pids"
        fi
    done
}

function gf {
    local content=$1
    find . -type f | xargs grep "$content"
}

function gfi {
    local content=$1
    find . -type f | xargs grep -i "$content"
}

function ge {
    local regex="$1"
    local directory="${2:-.}" 
    find "$directory" -type f -exec grep -nH "$regex" {} +
}

function gel {
    local regex="$1"
    local directory="${2:-.}" 
    find "$directory" -type f -exec grep -l "$regex" {} +
}

function rmc {
    local input
    read -p "Are you sure to remove all contents in current folder: $(pwd) (yes/no)" input

    if [ "$(pwd)" = "/" ]; then
        echo "You are not alloed to remove contents in root folder" >&2
        return 1
    fi

    if [ "$input" = "yes" ]; then
        rm -rf ./* .??*
    fi
}

function exe {
    local pid=$1
    readlink /proc/$pid/exe
}
### AD ###
