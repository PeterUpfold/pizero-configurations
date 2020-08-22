# Configure user accounts for Pi Zero systems. These are common user
# accounts. Role-specific accounts will be in the role specific module.
class pz_users {

  user { 'pi':
    ensure => absent
  }

  user { 'peter':
    ensure     => present,
    uid        => 1001,
    groups     => [ 'peter', 'adm', 'sudo' ],
    membership => minimum,
    home       => '/home/peter',
  }

  group { 'peter':
    ensure => present,
    gid    => 1001,
  }

  file { '/home/peter':
    ensure => directory,
    owner  => 'peter',
    group  => 'peter',
    mode   => '0700'
  }

  file { '/home/peter/.ssh':
    ensure => directory,
    owner  => 'peter',
    group  => 'peter',
    mode   => '0700'
  }

  file { '/home/peter/.ssh/authorized_keys':
    ensure => file,
    owner  => 'peter',
    group  => 'peter',
    mode   => '0600',
    source => ('puppet:///modules/pz_users/peter.authorized_keys')
  }
  file { '/etc/sudoers.d/015_peter-nopasswd':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0440',
    source => ('puppet:///modules/pz_users/015_peter-nopasswd')
  }

}
