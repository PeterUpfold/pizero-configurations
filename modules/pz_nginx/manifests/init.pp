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

  # backup script
  package { 'azure-cli':
    ensure => installed
  }
  package { 'curl':
    ensure => installed
  }

  file { '/etc/www-db-backup-config':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
    source => ('puppet:///modules/pz_nginx/volatile/www-db-backup-config')
  }

  file { '/etc/cron.daily/www-backup':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => ('puppet:///modules/pz_nginx/www-backup')
  }

}
