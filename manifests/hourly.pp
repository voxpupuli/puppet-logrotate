# Internal: Configure a host for hourly logrotate jobs.
#
# ensure - The desired state of hourly logrotate support.  Valid values are
#          'absent' and 'present' (default: 'present').
#
# Examples
#
#   # Set up hourly logrotate jobs
#   include logrotate::hourly
#
#   # Remove hourly logrotate job support
#   class { 'logrotate::hourly':
#     ensure => absent,
#   }
class logrotate::hourly($ensure='present') {
  require ::logrotate

  case $ensure {
    'absent': {
      $dir_ensure = $ensure
    }
    'present': {
      $dir_ensure = 'directory'
    }
    default: {
      fail("Class[Logrotate::Hourly]: Invalid ensure value '${ensure}'")
    }
  }

  file { '/etc/logrotate.d/hourly':
      ensure => $dir_ensure,
      owner  => 'root',
      group  => $::logrotate::rootgroup,
      mode   => '0755',
  }
  file { '/etc/cron.hourly/logrotate':
      ensure  => $ensure,
      owner   => 'root',
      group   => $::logrotate::rootgroup,
      mode    => '0555',
      source  => 'puppet:///modules/logrotate/etc/cron.hourly/logrotate',
      require => [ File['/etc/logrotate.d/hourly'], Package['logrotate'], ],
  }
}
