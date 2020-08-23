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

  file { '/etc/unbound/unbound.conf.d/cloudflare-dot.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_dns/cloudflare-dot.conf'),
    notify => Service['unbound']
  }

}
