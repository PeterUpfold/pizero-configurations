# Unbound DNS forwarder with DoH/DoT
class pz_dns {

  package { 'unbound':
    ensure => latest,
  }

  service { 'unbound':
    ensure  => running,
    enable  => true,
    require => Package['unbound']
  }

}
