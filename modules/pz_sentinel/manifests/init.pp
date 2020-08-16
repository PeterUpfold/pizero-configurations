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
    require => Serivce['rsyslog']
  }

}
