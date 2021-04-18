# Remote system syslog for local network
class pz_syslog {
  package { 'rsyslog':
    ensure => installed
  }
  service { 'rsyslog':
    enable => true
  }
  file { '/etc/rsyslog.conf':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_syslog/rsyslog.conf')
  }
  file { '/etc/logrotate.d/remote_logs':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_syslog/remote_logs.logrotate')
  }
}
