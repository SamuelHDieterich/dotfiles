# Startx
if [ (tty) = "/dev/tty1" ]
	pgrep dwm || startx
end


## EXPORT
export TERM="xterm-256color"
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export EDITOR="vim"
#export MANPAGER="sh -c 'col -bx | bat -l man -p'"


# ls -> exa
alias ls='exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'
alias ll='exa -l --color=always --group-directories-first'
alias lt='exa -aT --color=always --group-directories-first'
alias l.='exa -a | egrep "^\."'

# Pacman and Yay
alias pacsyu='sudo pacman -Syyu'
alias yaysua='yay -Sua'
alias cleanup='sudo pacman -Rns (pacman -Qtdq)'

# Colorize grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'


# Interactive mode (?)
if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Vim maps
stty -ixon
