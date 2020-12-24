#!/bin/bash
#
# Bootstrap a semi-manual install of Smokeping
#
#
SP_ROOT=/opt/smokeping
SP_UNPACK_ROOT=$(mktemp -d)
TARBALL="https://oss.oetiker.ch/smokeping/pub/smokeping-2.7.3.tar.gz"
TARBALL_SUM=430fd58030a494068a897f772c052fc0979ebdd38d1859a03820e098628d36b4
VERSION_STRING=smokeping-2.7.3
WEBSERVER_DIR=/var/www/smokeping

mkdir -p "${SP_UNPACK_ROOT}"
cd "${SP_UNPACK_ROOT}"

if [ -f smokeping.tar.gz ]; then
    rm -f -- smokeping.tar.gz
fi

curl -s "${TARBALL}" -o smokeping.tar.gz
exitcode=$?

if [ $exitcode -ne 0 ]; then
    echo "Failed to download $TARBALL with $exitcode".
    exit $exitcode
fi

sum=$(shasum -a 256 smokeping.tar.gz)

if [ "$sum" != "$TARBALL_SUM" ]; then
    echo "SHA256 sum $sum did not match $TARBALL_SUM. Aborting"
    exit 1
fi

# extract
tar xzvf smokeping.tar.gz

cd $VERSION_STRING

# configure
./configure --prefix=$SP_ROOT

exitcode=$?
if [ $exitcode -ne 0 ]; then
    echo "Failed to ./configure with $exitcode".
    exit $exitcode
fi

make install

exitcode=$?
if [ $exitcode -ne 0 ]; then
    echo "Failed to make install with $exitcode".
    exit $exitcode
fi

mkdir -p "${WEBSERVER_DIR}"
cp -Rv $SP_ROOT/htdocs "${WEBSERVER_DIR}"


cd "${SP_ROOT}"