abbr -a c cargo
abbr -a vim nvim
abbr -a e nvim
abbr -a m make
abbr -a g git
abbr -a gc 'git checkout'
abbr -a vimdiff 'nvim -d'
abbr -a ct 'cargo t'

# special stuff
abbr -a Ef 'nvim ~/.config/fish/config.fish'
abbr -a Ev 'vim ~/.config/nvim/init.vim'
abbr -a gs "git status"
abbr -a gits "git status"
abbr -a gl "git log --graph --decorate --oneline"
abbr -a gc 'git clone'
abbr -a cc "checkout -- ."
abbr -a gs 'git status -s'
abbr -a ca 'git commit -a -m'
abbr -a lazy "git add -A && git commit -m 'Update some files' && git push "
abbr -a cnet "git clone git@github.com:jethrosun/NetBricks.git -b dev ~/dev/netbricks && cd ~/dev/netbricks && ./build.sh"
abbr -a net "cd ~/dev/netbricks/"
abbr -a pg "cd ~/dev/pktgen-dpdk/"

# if test -e ~/data/cargo-target
#     setenv CARGO_TARGET_DIR ~/data/cargo-target
# end
#
# # source the devstack xxx file if I am in a devstack
# if [ -e /opt/stack/devstack/openrc ]; then
#   echo -e "\e[37mbtw: enabling __Devstack__ from the default location...\e[0m";
#   source /opt/stack/devstack/openrc
# fi
#
# export LD_LIBRARY_PATH=/usr/local/lib
#
# # NetBricks Env
# #if [ -e $HOME/dev/netbricks/native ]; then
# #echo -e "\e[37mbtw: enabling __libzcsi__ from the default location...\e[0m";
# #export LD_LIBRARY_PATH=/usr/local/lib:~/dev/netbricks/native
# #fi
#
# # OpenNetVM Env
# if [ -e /home/jethros/dev/openNetVM ]; then
#   if [[ "$OPEN_NET_VM" ]]; then
#     echo -e "\e[37mbtw: enabling __OpenNetVM__ as configured...\e[0m";
#     export ONVM_HOME=/home/jethros/dev/openNetVM
#     export RTE_SDK=/home/jethros/dev/openNetVM/dpdk
#     export RTE_TARGET=x86_64-native-linuxapp-gcc
#     export ONVM_NUM_HUGEPAGES=10
#     export ONVM_NIC_PCI=" 01:00.0 01:00.1 "
#   fi
# fi
#
# # just to make my life easier..
# if [ -e ~/dev/netbricks/ ]; then
#   echo -e "\e[37mbtw: aliasing net, netd, lpm, chain, op, opd, pg, cnet, recon...\e[0m";
#   alias net="cd ~/dev/netbricks/"
#   alias netd="cd ~/dev/netbricks/3rdparty/dpdk/examples"
#   alias lpm="cd ~/dev/netbricks/test/lpm/"
#   alias chain="cd ~/dev/netbricks/test/chain-test/"
#   alias op="cd ~/dev/openNetVM/"
#   alias opd="cd ~/dev/openNetVM/dpdk/examples"
#   alias recon="cd ~/dev/netbricks/test/tcp-reconstruction"
# fi
#



complete --command aurman --wraps pacman

if command -v aurman > /dev/null
	abbr -a p 'aurman'
	abbr -a up 'aurman -Syu'
else
	abbr -a p 'sudo pacman'
	abbr -a up 'sudo pacman -Syu'
end

if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ls 'exa'
	abbr -a ll 'exa -l'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# Set envvars since we don't have .pam_environment
setenv EDITOR nvim
setenv BROWSER links
setenv NAME "Jethro Shuwen Sun"
setenv EMAIL jethro.sun7@gmail.com
setenv CARGO_INCREMENTAL 1
setenv RUSTFLAGS "-C target-cpu=native"
setenv RUST_BACKTRACE 1
setenv LESS "-F -X -R"
if test -e ~/data/cargo-target
	setenv CARGO_TARGET_DIR ~/data/cargo-target
end
set PATH $PATH ~/.cargo/bin

# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

function fish_prompt
  set_color white
  echo -n "["(date "+%H:%M")"] "
  set_color yellow
  echo -n (whoami)
  set_color normal
  echo -n '@'
  set_color blue
  echo -n (hostname)" "
  set_color green
  echo -n (prompt_pwd)
  set_color brown
  printf '%s ' (__fish_git_prompt)
  set_color red
  if [ (whoami) = "root" ]
    echo -n '# '
  else
    echo -n '$ '
  end
  set_color normal
end

function fish_greeting
	echo
	echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m"
	echo
	echo -ne (\
		df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
		awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
		sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
		paste -sd ''\
	)
	echo

	echo -e " \\e[1mNetwork:\\e[0m"
	echo
	# http://tdt.rocks/linux_network_interface_naming.html
	echo -ne (\
		ip addr show up scope global | \
			grep -E ': <|inet' | \
			sed \
				-e 's/^[[:digit:]]\+: //' \
				-e 's/: <.*//' \
				-e 's/.*inet[[:digit:]]* //' \
				-e 's/\/.*//'| \
			awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
			sort | \
			#column -t -R1 | \
			# public addresses are underlined for visibility \
			sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
			# private addresses are not \
			sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
			# unknown interfaces are cyan \
			sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
			# ethernet interfaces are normal \
			sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
			# wireless interfaces are purple \
			sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
			# wwan interfaces are yellow \
			sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
			sed 's/$/\\\e[0m/' | \
			sed 's/^/\t/' \
		)
	echo
	set_color normal
end

