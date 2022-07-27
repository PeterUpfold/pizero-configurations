# Configure user accounts for Pi Zero systems. These are common user
# accounts. Role-specific accounts will be in the role specific module.
class pz_users {

  user { 'pi':
    ensure => absent
  }

  user { 'peter':
    ensure     => present,
    uid        => 1000, # as of Bullseye, no pi user is created and we will have 1000 for the first user
    groups     => [ 'peter', 'adm', 'sudo' ],
    membership => minimum,
    home       => '/home/peter',
  }

  group { 'peter':
    ensure => present,
    gid    => 1000, # as of Bullseye, no pi user is created and we will have 1000 for the first user
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

  file { '/home/peter/.screenrc':
    ensure => file,
    owner  => 'peter',
    group  => 'peter',
    mode   => '0600',
    source => ('puppet:///modules/pz_users/.screenrc')
  }

  group { 'deploybot':
    ensure => present,
    gid    => 1003
  }

  user { 'deploybot':
    ensure     => present,
    uid        => 1003,
    groups     => [ 'deploybot' ],
    membership => minimum,
    home       => '/home/deploybot'
  }

  file { '/home/deploybot':
    ensure => directory,
    owner  => 'deploybot',
    group  => 'deploybot',
    mode   => '0700'
  }

  file { '/home/deploybot/.ssh':
    ensure => directory,
    owner  => 'deploybot',
    group  => 'deploybot',
    mode   => '0700'
  }

  file { '/home/deploybot/.ssh/id_ecdsa':
    ensure => file,
    owner  => 'deploybot',
    group  => 'deploybot',
    mode   => '0600',
    source => ('puppet:///modules/pz_users/volatile/deploybot_id_ecdsa')
  }

  file { '/home/deploybot/.ssh/id_ecdsa.pub':
    ensure => file,
    owner  => 'deploybot',
    group  => 'deploybot',
    mode   => '0600',
    source => ('puppet:///modules/pz_users/deploybot_id_ecdsa.pub')
  }

}
