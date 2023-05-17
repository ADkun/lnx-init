### AD ###
if [[ $- == *i* ]]; then
    PS1='\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\]\$'
fi
shopt -s autocd

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

# find grep
alias fig='FgFunc(){ find . -type f | while read -r line; do res=$(grep -a "$1" $line); if [ -n "$res" ];then PrintGreen "$line:"; Print "$res"; res=""; fi; done; };FgFunc'
alias figl='FgFunc(){ find . -type f | while read -r line; do res=$(grep -a "$1" $line); if [ -n "$res" ];then echo "$line"; res=""; fi; done; };FgFunc'
alias figi='FgFunc(){ find . -type f | while read -r line; do res=$(grep -ai "$1" $line); if [ -n "$res" ];then PrintGreen "$line"; Print "$res"; res=""; fi; done; };FgFunc'
alias figil='FgFunc(){ find . -type f | while read -r line; do res=$(grep -ai "$1" $line); if [ -n "$res" ];then echo "$line";fi; done; };FgFunc'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# ps grep kill
alias pg='PgFunc(){ ps -ef|grep -v grep|grep -i $1; };PgFunc'

# find grep
alias ff='FfFunc(){ find . -type f|grep -i $1; }; FfFunc'
alias fd='FdFunc(){ find . -type d|grep -i $1; }; FdFunc'
alias cdff='DffFunc(){ cd $(dirname $(ff $1 | head -n $2 | tail -n 1)); }; DffFunc'
alias cdff='DffFunc(){ cd $(dirname $(ff $1 | head -n $2 | tail -n 1)); }; DffFunc'

# locate grep
alias lc='updatedb;locate'
alias lg='LgFunc(){ updatedb;locate $1|grep -i $2; };LgFunc'

# ll grep
alias l='ll'
alias llg='LlgFunc(){ ll|grep -i $1; };LlgFunc'
alias lsg='LsgFunc(){ ls|grep -i $1; };LsgFunc'

# strings grep
alias strg='StrgFunc(){ strings $1|grep -i $2; };StrgFunc'

# chown
alias chownr='ChownrFunc(){ chown -R $1:$1 $2; };ChownrFunc'
alias chownf='ChownfFunc(){ chown $1:$1 $2; };ChownfFunc'

# Clear file
alias wipef='WipefFunc(){ echo "">$1; };WipefFunc'

# systemctl
alias scs='ScstartFunc(){ systemctl start $1; };ScstartFunc'
alias scr='ScstartFunc(){ systemctl restart $1; };ScstartFunc'
alias sct='ScstopFunc(){ systemctl stop $1; };ScstopFunc'
alias sca='ScstatusFunc(){ systemctl status $1; };ScstatusFunc'
alias sctl='systemctl list-units --type=service'

# git
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

# ssh
alias s='SFunc(){ ssh ${1}@${2}; };SFunc'

function lsofd {
    local arg;arg=
    for arg in "$@"; do
        val=$(echo "${arg}" | sed -e "s;--[^=]*=;;")
        local cur_dir="$arg"
        PrintBlue "$cur_dir"
        lsof +D "$cur_dir"
        echo ""
    done
}

function lsofi {
    local arg;arg=
    for arg in "$@"; do
        val=$(echo "${arg}" | sed -e "s;--[^=]*=;;")
        local cur_port="$arg"
        PrintBlue "$cur_port"
        lsof -i:"$cur_port"
        echo ""
    done
}
### AD ###