# Reader for Sentinel log queue
class pz_sentinel_reader {

  vcsrepo { '/home/sentinel/sentinel':
    ensure   => latest,
    provider => git,
    source   => 'ssh://git@github.com/PeterUpfold/sentinel-queue-to-file.git',
    user     => 'deploybot',
    require  => [File['/home/sentinel']]
  }

  group { 'sentinel':
    ensure => present,
  }

  user { 'sentinel':
    ensure     => present,
    groups     => [ 'sentinel' ],
    membership => 'minimum'
  }

  file { '/home/sentinel':
    ensure => directory,
    mode   => '0770',
    owner  => 'sentinel',
    group  => 'deploybot',
  }

  file { '/etc/cron.d/sentinel_reader':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => ('puppet:///modules/pz_sentinel_reader/sentinel_reader.cron')
  }

}
