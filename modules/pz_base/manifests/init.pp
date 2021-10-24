# Base software packages and common configurations to all system roles
class pz_base {
  $base_packages = [ 'build-essential', 'curl', 'wget', 'screen', 'tmux', 'unattended-upgrades', 'git', 'logrotate', 'rsync', 'vim' ]

  package { $base_packages:
    ensure => latest
  }
  # SSH configuration
  file { '/etc/ssh/sshd_config':
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_base/sshd_config')
  }

  # unattended upgrades
  file { '/etc/apt/apt.conf.d/20auto-upgrades':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['unattended-upgrades'],
    source  => ('puppet:///modules/pz_base/20auto-upgrades')
  }
  file { '/etc/apt/apt.conf.d/50unattended-upgrades':
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['unattended-upgrades'],
    source  => ('puppet:///modules/pz_base/50unattended-upgrades')
  }

  # connectivity check script
  file { '/usr/local/bin/connectivity-check':
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => ('puppet:///modules/pz_base/connectivity-check.sh')
  }

  file { '/etc/cron.d/connectivity-check':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_base/connectivity-check.cron')
  }

}
