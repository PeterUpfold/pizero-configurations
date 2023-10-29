# Install a Zabbix server instance
class pz_zabbixserver {
  # script to install repo
  file { '/usr/local/bin/install-zabbix-repo.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => ('puppet:///modules/pz_zabbixserver/install-zabbix-repo.sh'),
  }

  # install the repo
  exec { 'install-zabbix-repo':
    command => '/usr/local/bin/install-zabbix-repo.sh',
    require => File['/usr/local/bin/install-zabbix-repo.sh'],
  }
}
