HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
bindkey "^[[5~" history-beginning-search-backward  # pgup
bindkey "^[[6~" history-beginning-search-forward   # pgdn
bindkey "^[]" _history-complete-older
bindkey "^[/" list-choices
bindkey "^[?" list-choices
bindkey "^[[7~" beginning-of-line
bindkey "^[[8~" end-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

bindkey "^[[3~" delete-char     # delete
bindkey "^[[3^" delete-word     # ctrl-delete
bindkey "^[^[[D" backward-word  # alt left
bindkey "^[^[[C" forward-word   # alt right

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
precmd ()
{
    eval PS1="%F{green}%Bnuc:%~%f%b$'\n'-$' '"
    test -n "$DISPLAY" && xtitle "nuc $PWD"
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
alias clr="printf '\ec'"
alias ll='ls -la'
alias xpwd='printf $PWD | xclip -i'
alias te=emacsclient
alias locaml='rlwrap ocaml'
alias mpvin='mpv --playlist=-'
alias xco='xclip -se c -o'
alias xci='xclip -se c -i'
alias h='history'
alias ps='echo bad habits die hard (use \\ps and think) - $*'
alias which-command &>/dev/null && unalias which-command
alias qdb="gdb -q"

sudo () command sudo ${DISPLAY+-A} $*
test -n "${TMUX}" -a -n "${commands[tmux]}" && export TERM=tmux-256color
export SUDO_ASKPASS=$HOME/bin/askpass
ulimit -s 2048
mpvrand () { find ${1-$PWD} -type f | sort -R | mpv --playlist=- "$@"; }

test "$TERM" = "dumb" && {
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
}
tp () curl -L -F 'tpaste=<-' tpaste.us
pu () curl --silent --data-binary "@${1:-/dev/stdin}" bsd.ac:42069

todo() {
    if test $# -gt 0; then
        ln -s "$1" "$HOME/1/${2-$(basename $1)}"
    else
        cd &>/dev/null "$HOME/1/"
        ls
    fi
}
