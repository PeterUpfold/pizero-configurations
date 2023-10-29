# Zabbix agent only
class pz_zabbixagent {
  # script to install repo
  file { '/usr/local/bin/install-zabbix-repo.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => ('puppet:///modules/pz_zabbixagent/install-zabbix-repo.sh'),
  }
  $za_packages = ['zabbix-agent']

  # install the repo
  exec { 'install-zabbix-repo':
    command => '/usr/local/bin/install-zabbix-repo.sh',
    require => File['/usr/local/bin/install-zabbix-repo.sh'],
    creates => '/etc/apt/sources.list.d/zabbix.list',
  }

  package { $za_packages:
    ensure => latest,
  }
  service { 'zabbix-agent':
    ensure  => running,
    enable  => true,
    require => Package[$za_packages],
  }
  file { '/etc/zabbix/zabbix_agentd.conf':
    ensure => file,
    owner  => 'zabbix',
    group  => 'zabbix',
    mode   => '0600',
    source => ("puppet:///modules/pz_zabbixagent/volatile/${trusted['hostname']}_zabbix_agentd.conf")
  }
  file { '/etc/zabbix/psk':
    ensure => file,
    owner  => 'zabbix',
    group  => 'zabbix',
    mode   => '0600',
    source => ("puppet:///modules/pz_zabbixagent/volatile/${trusted['hostname']}_psk")
  }
}
