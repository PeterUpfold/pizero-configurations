# Cacti

Enable Spine and friends to use ICMP ping

    $ sudo setcap cap_net_raw+epi /usr/local/spine/bin/spine
    $ sudo setcap cap_net_raw+epi /usr/bin/php7.3
