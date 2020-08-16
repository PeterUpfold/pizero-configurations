# Configure user accounts for Pi Zero systems.
class pz_users {

  user { 'pi':
    ensure => absent
  }

  user { 'peter':
    ensure => present,
    uid    => 1001,
  }

  file { '/home/peter':
    ensure => directory,
    owner  => 'peter',
    group  => 'peter',
    mode   => '0700'
  }

}
