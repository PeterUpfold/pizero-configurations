# Nginx web server
class pz_nginx {
  package { 'nginx':
    ensure => installed
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx']
  }
}
