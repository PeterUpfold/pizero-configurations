# This role provides a HTTP proxy
class pz_httpproxy {
  $httpproxy_packages = [ 'tinyproxy' ]

  package { $httpproxy_packages:
    ensure => latest
  }

  service { 'tinyproxy':
    ensure  => running,
    enable  => true,
    require => Package[$httpproxy_packages]
  }

  file { '/etc/tinyproxy/tinyproxy.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_httpproxy/tinyproxy.conf'),
    require => Package['tinyproxy'],
    notify  => Service['tinyproxy']
  }

}
