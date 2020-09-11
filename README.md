# PiZero-Configurations

This repository contains Puppet-based system configurations for various Raspberry Pi Zero W systems
that I use for bespoke home automation/monitoring.

## Usage

    sudo apt-get install puppet git
    sudo puppet module install puppetlabs-vcsrepo
    git clone https://github.com/PeterUpfold/pizero-configurations.git
    cd pizero-configurations
    sudo puppet apply --verbose --modulepath=modules/:/etc/puppet/code/modules/ [role].pp
