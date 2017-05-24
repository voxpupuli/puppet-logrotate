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
class logrotate::hourly(
  $ensure = 'present',
) {

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

  file { "${logrotate::rules_configdir}/hourly":
      ensure => $dir_ensure,
      owner  => $logrotate::root_user,
      group  => $logrotate::root_group,
      mode   => '0755',
  }
  logrotate::cron { 'hourly':
    ensure  => $ensure,
    require => File["${logrotate::rules_configdir}/hourly"],
  }
}
