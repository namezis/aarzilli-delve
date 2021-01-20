#!/bin/bash
set -e
set -x

apt-get -qq update
apt-get install -y dwz wget make git gcc curl jq
dwz --version

version=$1
arch=$2

curl 'https://golang.org/dl/?mode=json&include=all' | jq '.[].version' --raw-output | egrep ^go$version'($|\.|beta|rc)' | head -1 | cut -c3-

echo "Go $version on $arch"

export GOROOT=/usr/local/go/"$version"
if [ ! -d "$GOROOT" ]; then
  wget -q https://dl.google.com/go/"${version}".linux-"${arch}".tar.gz
  mkdir -p /usr/local/go
  tar -C /usr/local/go -xzf "${version}".linux-"${arch}".tar.gz
  mv -f /usr/local/go/go "$GOROOT"
fi

GOPATH=$(pwd)/go
export GOPATH
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
go version

uname -a
echo "$PATH"
echo "$GOROOT"
echo "$GOPATH"
cd delve
make test
