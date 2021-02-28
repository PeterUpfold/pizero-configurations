# Smokeping monitoring
class pz_smokeping {
  $sp_packages = [ 'fping', 'curl', 'dnsutils', 'perl', 'wget', 'spawn-fcgi', 'libfcgi-perl', 'libconfig-grammar-perl', 'libdigest-perl-md5-perl', 'rrdtool', 'librrds-perl', 'libnet-ssleay-perl'  ]

  package { $sp_packages:
    ensure => installed
  }

  group { 'smokeping':
    ensure => present,
    gid    => '1007'
  }

  user { 'smokeping':
    ensure     => present,
    uid        => '1007',
    groups     => [ 'smokeping' ],
    membership => minimum
  }

  file { '/home/smokeping':
    ensure => directory,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0700'
  }

  file { '/opt/smokeping':
    ensure => directory,
    owner  => 'smokeping',
    group  => 'www-data',
    mode   => '0755'
  }

  file { '/opt/smokeping/etc':
    ensure => directory,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0755'
  }

  file { '/opt/smokeping/etc/smokemail':
    ensure => file,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0644',
    source => ('puppet:///modules/pz_smokeping/smokemail')
  }


  file { '/opt/smokeping/etc/config':
    ensure => file,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0644',
    source => ('puppet:///modules/pz_smokeping/volatile/config')
  }


  file { '/opt/smokeping/etc/basepage.html':
    ensure => file,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0644',
    source => ('puppet:///modules/pz_smokeping/basepage.html')
  }

  file { '/opt/smokeping/sp-install.sh':
    ensure => file,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0755',
    source => ('puppet:///modules/pz_smokeping/sp-install.sh')
  }

  exec { 'sp-install':
    command => '/opt/smokeping/sp-install.sh',
    user    => 'smokeping',
    creates => '/opt/smokeping/.sp-install-complete',
    require => File['/opt/smokeping/sp-install.sh'],
    timeout => 0
  }

  file { '/etc/nginx/sites-available/smokeping':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_smokeping/volatile/smokeping.server')
  }

  file { '/etc/nginx/sites-enabled/smokeping':
    ensure => link,
    target => '/etc/nginx/sites-available/smokeping'
  }

  file { '/opt/smokeping/cache':
    ensure => directory,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0755'
  }

  file { '/opt/smokeping/data':
    ensure => directory,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0750'
  }

  file { '/opt/smokeping/var':
    ensure => directory,
    owner  => 'smokeping',
    group  => 'smokeping',
    mode   => '0750'
  }

  file { '/etc/systemd/system/smokeping-fastcgi.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_smokeping/smokeping-fastcgi.service'),
    require => Exec['sp-install']
  }

  service { 'smokeping-fastcgi':
    ensure  => running,
    enable  => true,
    require => [File['/etc/systemd/system/smokeping-fastcgi.service'],Exec['smokeping-fastcgi-systemd-daemon-reload']]
  }

  exec { 'smokeping-fastcgi-systemd-daemon-reload':
    command => '/bin/systemctl daemon-reload',
    require => File['/etc/systemd/system/smokeping-fastcgi.service']
  }

  exec { 'smokeping-systemd-daemon-reload':
    command => '/bin/systemctl daemon-reload',
    require => File['/etc/systemd/system/smokeping.service']
  }

  file { '/etc/systemd/system/smokeping.service':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_smokeping/smokeping.service'),
    require => [File['/opt/smokeping/etc/config'],Exec['sp-install']]
  }

  service { 'smokeping':
    ensure  => running,
    enable  => true,
    require => [File['/etc/systemd/system/smokeping.service'],Exec['smokeping-systemd-daemon-reload']]
  }

}
