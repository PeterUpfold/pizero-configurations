# Install a Zabbix server instance
class pz_zabbixserver {
  $zabbix_packages = ['zabbix-server-mysql','zabbix-frontend-php','zabbix-nginx-conf','zabbix-sql-scripts','zabbix-agent']
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
    creates => '/etc/apt/sources.list.d/zabbix.list',
  }

  package { $zabbix_packages:
    ensure  => installed,
    require => Exec['install-zabbix-repo'],
  }

  file { '/etc/zabbix/nginx.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_zabbixserver/volatile/zabbix.server'),
    require => Package[$zabbix_packages],
  }

  file { '/etc/nginx/sites-enabled/zabbix':
    ensure  => link,
    target  => '/etc/zabbix/nginx.conf',
    require => Package[$zabbix_packages],
  }
  # allow running temp script
  file { '/etc/sudoers.d/20-zabbix':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_zabbixserver/zabbix.sudo'),
    require => Package[$zabbix_packages],
  }

  # Zabbix agentx
  file { '/etc/zabbix/zabbix_agentd.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_zabbixserver/zabbix_agentd.conf'),
    require => Package[$zabbix_packages],
  }
  file { '/etc/zabbix/zabbix_agentd.d/simpletemp.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_zabbixserver/simpletemp.conf'),
    require => Package[$zabbix_packages],
  }

}
