#!/bin/bash
#
# Install SmokePing from binary distribution
#
#
# I don't really like the Debian package depending upon Apache2

set -e -u -o pipefail

HASH=430fd58030a494068a897f772c052fc0979ebdd38d1859a03820e098628d36b4
ROOT=/opt/smokeping
TMPDIR=$(mktemp -d)

cd $TMPDIR

curl --fail-early 'https://oss.oetiker.ch/smokeping/pub/smokeping-2.7.3.tar.gz' -o smokeping.tar.gz

if [ "$(shasum -a 256 smokeping.tar.gz | awk '{print $1}')" != "$HASH" ]; then
    logger "failed hash validation on smokeping.tar.gz"
    exit 1
fi

tar xzf smokeping.tar.gz

rsync -r smokeping-2.7.3/ $ROOT/

cd $ROOT/

./configure
make

cd $ROOT
rm -rf -- $TMPDIR

touch $ROOT/.sp-install-complete
