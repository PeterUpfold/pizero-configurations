# MariaDB database server
class pz_mariadb {
  package { 'mariadb-server':
    ensure => latest
  }
  package { 'libmariadb-dev':
    ensure => latest
  }
}
