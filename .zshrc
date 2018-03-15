HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
bindkey "^[]" _history-complete-older
bindkey "^[/" list-choices
bindkey "^[?" list-choices
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char

fpath=(~/.config/zsh $fpath)

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/malc/.zshrc'

# http://stackoverflow.com/questions/444951/zsh-stop-backward-kill-word-on-directory-delimiter
autoload -U select-word-style
select-word-style bash
#WORDCHARS='*?_-.[]~&;!#$%^(){}<>/'

autoload -Uz compinit
compinit

zstyle ':completion:history-words:*' list yes
zstyle ':completion:history-words:*' remove_all_dups yes
zstyle ':completion:history-words:*' stop yes
zstyle ':completion:history-words:*' menu yes
zstyle ':completion:*' menu select
#zstyle ':completion:*' rehash true

setopt menu_complete
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt HIST_IGNORE_DUPS

unt () { tar xf $1 && cd ${1%%.(t?z|tar)*}; }
unz () { unzip -L $1 -d ${1%%.zip}; }
unr () { unrar x -cl $1 ${1%%.rar}/; }

xtitle ()
{
    printf "\033]0;$1\007"
}
local nl=$'\n'
precmd ()
{
    PS1="%F{green}%B%~%f%b$nl- "
    test -n "$DISPLAY" && xtitle "$PWD"
}

tobld ()
{
    test -n "$1" && {
        sansext=${1%%.tar*}
        dst="$HOME/x/bld/$sansext"
        mkdir -p "$dst"
        tar xf "$1" -C "$dst"
        cd "$dst"
    }
}

alias ..='cd ..'
alias clr="printf '\e[1;1H'"
alias ll='ls -la'
alias xpwd='printf $PWD | xclip -i'
alias te=emacsclient
alias locaml='rlwrap ocaml'
alias mpvin='(read a; mpv "$a")'
alias h='history'
alias psax="ps ax | grep -v ]$"
alias which-command &>/dev/null && unalias which-command
sudo () command sudo ${DISPLAY+-A} $*
test -n "${TMUX}" -a -n "${commands[tmux]}" && export TERM=tmux-256color
export SUDO_ASKPASS=$HOME/bin/askpass
ulimit -s 512
mpvrand () { find -type f | sort -R | mpv -playlist - "$@"; }
