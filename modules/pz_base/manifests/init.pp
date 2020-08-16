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

}
