# Support for a Smokeping installation, without using Debian packages which bring along Apache
class pz_smokeping {
  $sp_packages = [ 'rrdtool', 'librrds-perl', 'libssl-dev', 'fping', 'curl', 'dnsutils', 'perl' ]

  package { $sp_packages:
    ensure => latest
  }

  file { '/opt/smokeping':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755'
  }

  file { '/opt/smokeping/pu_bootstrapper.sh':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => ('puppet:///modules/pz_smokeping/bootstrapper.sh')
  }

  exec { 'bootstrapper':
    command => '/opt/smokeping/pu_bootstrapper.sh',
    require => [File['/opt/smokeping/pu_bootstrapper.sh'],Package[$sp_packages]],
    returns => 0,
    timeout => 0
  }

}
