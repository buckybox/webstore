#!/bin/bash -eux

# Install PhantomJS on a Debian-like distro.

VERSION=2.1.1
ARCH=$(uname -m)
PHANTOM_JS="phantomjs-$VERSION-linux-$ARCH"

cd /tmp
wget --no-verbose https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
tar xjf $PHANTOM_JS.tar.bz2
mv $PHANTOM_JS /usr/local/share
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
