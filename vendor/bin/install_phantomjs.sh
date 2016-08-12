#!/bin/bash -eux

# Install PhantomJS on a Debian-like distro.

VERSION=2.1.1
PHANTOM_JS=phantomjs-$VERSION-linux-x86_64

cd /tmp
wget --no-verbose https://github.com/Medium/phantomjs/releases/download/v$VERSION/$PHANTOM_JS.tar.bz2
tar xf $PHANTOM_JS.tar.bz2
mv $PHANTOM_JS /usr/local/share
ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin
