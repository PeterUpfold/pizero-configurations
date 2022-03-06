# Rebuild PiZero2


Install Raspi OS Lite

    sudo systemctl enable --now ssh

    sudo apt-get install puppet git

    rsync -rvh -e ssh ~/Devel/Puppet/pizero-configurations/ pi@10.2.0.20:~/pizero-configurations

    cd pizero-configurations
    puppet apply --verbose --modulepath=modules/ base_only.pp
    puppet apply --verbose --modulepath=modules/ users.pp

    rsync -rvh -e ssh ~/Devel/Python3/eInkStatusMonitor/ peter@10.2.0.20:~/eInkStatusMonitor/