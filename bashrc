# NOTE:
#   This bash config file is modified from Jonhoo's bashrc file.

# IMPORTANT ENV
export OPEN_NET_VM=""
export EDITOR=vim

# Rust
if [[ -e $HOME/.cargo ]]; then
	source "$HOME/.cargo/env"
	echo -e '\e[37mbtw: Rust available so enable implicitly\e[0m';
	export RUST_BACKTRACE="1"
fi

# LLVM
#export C_INCLUDE_PATH=/usr/lib/llvm-6.0/lib/clang/6.0.0/include"${C_INCLUDE_PATH+:}${C_INCLUDE_PATH-}"


# If not running interactively, don't do anything
if [[ $- != *i* ]]; then
	# non-interactive
	alias echo=/bin/false
fi

# Make sure terminal is recognized
faking="no"
if [[ "$TERM" == "rxvt-unicode-256color" && ! -e "/usr/share/terminfo/r/$TERM" ]]; then
	if [ -e "/usr/share/terminfo/r/rxvt-256color" ]; then
		faking="nounicode"
		export TERM='rxvt-256color';
	else
		faking="vt100"
		export TERM='vt100';
	fi
fi

## I largely use this for remote server
export TERM=xterm

# Style with solarized
if [[ -e $HOME/dev/others/base16/builder/templates/shell ]]; then
	source "$HOME/dev/others/base16/builder/templates/shell/scripts/base16-atelier-dune.sh"
else
	if [[ "$TERM" == "linux" ]]; then
		echo -en "\e]P0002b36\e]P1dc322f\e]P2859900\e]P3b58900\e]P4268bd2\e]P5d33682\e]P62aa198\e]P7eee8d5\e]P9cb4b16\e]P8002b36\e]PA586e75\e]PB657b83\e]PC839496\e]PD6c71c4\e]PE93a1a1\e]PFfdf6e3"
		echo -e '\e[37mbtw: base16 shell style not available, emulating solarized\e[0m';
	else
		echo -e '\e[37mbtw: base16 shell style not available\e[0m';
	fi
fi

if [[ $faking == "nounicode" ]]; then
	echo -e '\e[37mbtw: rxvt-unicode not supported, faking rxvt...\e[0m';
elif [[ $faking == "vt100" ]]; then
	echo -e '\e[37mbtw: rxvt not supported, faking vt100...\e[0m';
fi

# Be nice to sysadmins
if [ -f /etc/bashrc ]; then
	echo -e '\e[37mbtw: merging master bashrc...\e[0m';
	source /etc/bashrc
elif [ -f /etc/bash.bashrc ]; then
	echo -e '\e[37mbtw: merging master bash.bashrc...\e[0m';
	source /etc/bash.bashrc
fi

# And to users who like to tweak
if [ -e "$HOME/.local/bashrc" ]; then
	echo -e '\e[37mbtw: merging local bashrc...\e[0m';
	source "$HOME/.local/bashrc"
fi

# Weston needs some custom vars
if [[ ! -z `pgrep weston` ]]; then
	export GDK_BACKEND="wayland"
	export CLUTTER_BACKEND="wayland"
	export SDL_VIDEODRIVER="wayland"
	export QT_QPA_PLATFORM="wayland-egl"
fi

[[ $- != *i* ]] && return;


PS1='\[\e[37m\][\A] \[\e[0;33m\]\u\[\e[0m\]@\[\e[35m\]\h \[\e[32m\]\w'

# Prompt
if [ -e /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
	source /usr/share/git-core/contrib/completion/git-prompt.sh
	# For unstaged(*) and staged(+) values next to branch name in __git_ps1
	GIT_PS1_SHOWDIRTYSTATE="enabled"
	GIT_PS1_SHOWUNTRACKEDFILES="enabled"
	PS1=$PS1'\[\e[35m\]`__git_ps1`'
	echo -e "\e[37mbtw: enabling git completion in prompt...\e[0m";
elif [ -e $HOME/.git-prompt.sh ]; then
	source $HOME/.git-prompt.sh
	# For unstaged(*) and staged(+) values next to branch name in __git_ps1
	GIT_PS1_SHOWDIRTYSTATE="enabled"
	GIT_PS1_SHOWUNTRACKEDFILES="enabled"
	PS1=$PS1'\[\e[35m\]`__git_ps1`'
	echo -e "\e[37mbtw: enabling git completion in prompt...\e[0m";
else
	wget -O ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
	source $HOME/.git-prompt.sh
	# For unstaged(*) and staged(+) values next to branch name in __git_ps1
	GIT_PS1_SHOWDIRTYSTATE="enabled"
	GIT_PS1_SHOWUNTRACKEDFILES="enabled"
	PS1=$PS1'\[\e[35m\]`__git_ps1`'
	echo -e "\e[37mbtw: enabling git completion in prompt (troublesome)...\e[0m";
fi

PS1=$PS1' \[\e[31m\]\$\[\e[0m\] '

# Prompt command (for SSH window titles)
if [ ! "$TERM" = "linux" ]; then
	export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
fi

# Solarized ls
if [ -e $HOME/.dircolors ]; then
	echo -e '\e[37mbtw: dircolors is available, yeehoo...\e[0m';
	eval "$(dircolors -b $HOME/.dircolors)"
else
	echo -e '\e[37mbtw: no dircolors available...\e[0m';
fi

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
alias man='man -P less'

# Don't autocomplete to hidden directories
bind 'set match-hidden-files off'

# Make working with Java a bit easier
export CLASSPATH="$CLASSPATH:."
if [ -e /usr/share/java ]; then
	export CLASSPATH="$CLASSPATH:/usr/share/java"
fi

# History management
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTIGNORE="clear:bg:fg:cd:cd -:cd ..:exit:date:w:* --help:ls:l:ll:lll"

# Autocomplete ignore
# LaTeX
export FIGNORE="$FIGNORE:.aux:.out:.toc"

# make less better
# X = leave content on-screen
# F = quit automatically if less than one screenfull
# R = raw terminal characters (fixes git diff)
#     see http://jugglingbits.wordpress.com/2010/03/24/a-better-less-playing-nice-with-git/
export LESS="-F -X -R"

# Color aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
# Common aliases
alias more='less'
# Convenience aliases
alias lll='ls -la'
alias ll='ls -l'
alias l='ls'
alias run='sudo systemctl start'
alias restart='sudo systemctl restart'
alias stop='sudo systemctl stop'
alias x='sudo netctl'
alias xt='date +%s'
alias ..='cd ..'
alias sduo='sudo'
alias workon='source .venv/bin/activate'
# make
alias ,='make'
# file handlers
#alias o='xdg-open'

# editing
alias e='$EDITOR'
alias Ev='vim ~/.config/nvim/init.vim'
alias Eb='vim ~/.bashrc'
# Safety first
alias mv='mv -i'
# git alias
alias gs="git status"
alias gits="git status"
alias gl="git log --graph --decorate --oneline"
alias gc='git checkout'
alias cc="checkout -- ."
alias gs='git status -s'
alias ca='git commit -a -m'
alias lazy="git add -A && git commit -m 'Update some files' && git push "

# use nvim if I set it up
if type nvim >/dev/null 2>/dev/null; then
	alias vi=nvim
	alias vim=nvim
	export EDITOR=nvim
fi

# Type - to move up to top parent dir which is a repository
function - {
local p=""
for f in `pwd | tr '/' ' '`; do
	p="$p/$f"
	if [ -e "$p/.git" ]; then
		cd "$p"
		break
	fi
done
}

# Replace part of current path and cd to it
function cdd {
	cd `pwd | sed "s/$1/$2/"`
}

# source the devstack xxx file if I am in a devstack
if [ -e /opt/stack/devstack/openrc ]; then
	echo -e "\e[37mbtw: enabling __Devstack__ from the default location...\e[0m";
	source /opt/stack/devstack/openrc
fi

export LD_LIBRARY_PATH=/usr/local/lib

# NetBricks Env
#if [ -e $HOME/dev/netbricks/native ]; then
	#echo -e "\e[37mbtw: enabling __libzcsi__ from the default location...\e[0m";
	#export LD_LIBRARY_PATH=/usr/local/lib:~/dev/netbricks/native
#fi

# OpenNetVM Env
if [[ "$OPEN_NET_VM" ]]; then
	echo -e "\e[37mbtw: enabling __OpenNetVM__ as configured...\e[0m";
	export ONVM_HOME=/home/jethros/dev/openNetVM
	export RTE_SDK=/home/jethros/dev/openNetVM/dpdk
	export RTE_TARGET=x86_64-native-linuxapp-gcc
	export ONVM_NUM_HUGEPAGES=10
	export ONVM_NIC_PCI=" 01:00.0 01:00.1 "
fi

# just to make my life easier..
if [ -e ~/dev/netbricks/ ]; then
	echo -e "\e[37mbtw: enabling __OpenNetVM__ as configured...\e[0m";
	alias net=cd ~/dev/netbricks/
	alias netd=cd ~/dev/netbricks/3rdparty/dpdk/examples
	alias lpm=cd ~/dev/netbricks/test/lpm/
	alias op=cd ~/dev/openNetVM/
	alias opd=cd ~/dev/openNetVM/dpdk/examples
fi

echo
# end of [.bashrc]
