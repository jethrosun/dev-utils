#!/bin/bash

set -e

# Update first
sudo apt-get update
sudo apt-get autoremove -y

# perf tunning stuff
sudo apt-get install -y  msr-tools linux-tools-generic


# Necessary tools to make my life easier
sudo apt-get install -y ranger bash-completion vim build-essential neovim silversearcher-ag tshark fish

# Everything we need to make NetBricks work

# sudo apt-get install -y git curl libssl-dev pkg-config #dpdk-igb-uio-dkms
# install ubuntu deps
# sudo apt-get install -y libgnutls30 libgnutls-openssl-dev libcurl4-gnutls-dev libnuma-dev libpcap-dev  libsctp-dev gcc
# install kernel headers
# sudo apt-get install -y linux-headers-"$(uname -r)"
# install clang with correct version and cmake

sudo apt-get install -y apt-utils build-essential pciutils linux-headers-"$(uname -r)" python python3
sudo apt-get install -y cmake musl-tools cmake bash llvm gcc pkg-config libclang-dev
sudo apt-get install -y libgnutls30 libcurl4-gnutls-dev libpcap-dev libnuma-dev libelf-dev
sudo apt-get install -y libssl-dev libgnutls-openssl-dev libcurl4-gnutls-dev libsctp-dev libevent-dev
# FIXME: careful with clang and LLVM, currently only LLVM 3.8 works
# sudo apt-get install -y clang-6.0

# rdr browser
sudo apt-get install -y chromium-chromedriver

# musl
sudo apt-get install -y musl-tools numactl gdb

## for transmission: libcurl-dev?
# sudo apt install -y libssl-dev libevent-dev

sudo apt install -y jq

# bcc
echo "Run https://github.com/iovisor/bcc/blob/master/INSTALL.md#ubuntu---binary"

if [ -e "$HOME/dev/netbricks" ]; then
	echo "Passing, netbricks exists.."
else
	# git repo
	mkdir -p ~/dev && cd ~/dev && git clone https://github.com/jethrosun/NetBricks.git -b expr netbricks
fi
