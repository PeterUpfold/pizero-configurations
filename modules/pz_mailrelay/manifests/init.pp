# Email relay server
class pz_mailrelay {
  package { 'postfix':
    ensure => installed
  }

  file { '/etc/postfix/main.cf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_mailrelay/volatile/main.cf'),
    require => Package['postfix']
  }

  file { '/etc/postfix/sasl/passwd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => ('puppet:///modules/pz_mailrelay/volatile/passwd'),
    require => Package['postfix']
  }

  exec { 'postmap-passwd':
    command => '/usr/sbin/postmap /etc/postfix/sasl/passwd',
    require => File['/etc/postfix/sasl/passwd']
  }

}

