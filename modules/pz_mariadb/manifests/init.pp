# MariaDB database server
class pz_mariadb {
  package { 'mariadb-server':
    ensure => latest
  }
  package { 'libmariadb-dev':
    ensure => latest
  }
  # backup script
  package { 'azure-cli':
    ensure => installed
  }
  package { 'curl':
    ensure => installed
  }

  # file { '/etc/www-db-backup-config':
  #   ensure => file,
  #   owner  => 'root',
  #   group  => 'root',
  #   mode   => '0600',
  #   source => ('puppet:///modules/pz_mariadb/volatile/www-db-backup-config')
  # }

  file { '/etc/cron.daily/db-backup':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => ('puppet:///modules/pz_mariadb/db-backup')
  }
}
