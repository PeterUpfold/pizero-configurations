# PiZero-Configurations

This repository contains Puppet-based system configurations for various Raspberry Pi Zero W systems
that I use for bespoke home automation/monitoring.

## Usage

    sudo apt-get install puppet git
    git clone https://github.com/PeterUpfold/pizero-configurations.git
    cd pizero-configurations
    sudo puppet apply --verbose --modulepath=modules/ [role].pp
