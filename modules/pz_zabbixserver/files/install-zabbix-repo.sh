#!/bin/bash

pushd /tmp

wget https://repo.zabbix.com/zabbix/6.0/raspbian/pool/main/z/zabbix-release/zabbix-release_6.0-5+debian11_all.deb
dpkg -i zabbix-release_6.0-5+debian11_all.deb
apt -y update

popd