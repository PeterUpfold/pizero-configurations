# This role provides the ability to watch over a semi-trusted device to 
# audit its behaviour over time.
class pz_sentinel {
  $sentinel_packages = [ 'rsyslog' ]

  package { $sentinel_packages:
    ensure => latest
  }

  service { 'rsyslog':
    ensure  => running,
    enable  => true,
    require => Package[$sentinel_packages]
  }

  file { '/etc/rsyslog.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Service['rsyslog'],
    source  => ('puppet:///modules/pz_sentinel/rsyslog.conf')
  }

  file { '/var/log/remote':
    ensure => directory,
    owner  => 'root',
    group  => 'adm',
    mode   => '0770',
  }

  group { 'sentinel':
    ensure => present,
    gid    => '1002'
  }

  user { 'sentinel':
    ensure     => present,
    uid        => '1002',
    groups     => [ 'sentinel' ],
    membership => 'minimum'
  }

  file { '/home/sentinel':
    ensure => directory,
    mode   => '0770',
    owner  => 'sentinel',
    group  => 'deploybot',
  }

  file { '/home/sentinel/.ssh':
    ensure => directory,
    mode   => '0700',
    owner  => 'sentinel',
    group  => 'sentinel',
  }

  file { '/home/sentinel/.ssh/id_rsa':
    ensure => file,
    mode   => '0600',
    owner  => 'sentinel',
    group  => 'sentinel',
    source => ('puppet:///modules/pz_sentinel/volatile/sentinel_key')
  }

  file { '/home/sentinel/.ssh/id_rsa.pub':
    ensure => file,
    mode   => '0600',
    owner  => 'sentinel',
    group  => 'sentinel',
    source => ('puppet:///modules/pz_sentinel/sentinel_key.pub')
  }

  vcsrepo { '/home/sentinel/sentinel':
    ensure   => latest,
    provider => git,
    source   => 'ssh://git@github.com/PeterUpfold/sentinel.git',
    user     => 'deploybot',
    require  => File['/home/deploybot/.ssh/id_ecdsa']
  }

}
