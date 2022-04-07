# Internal: Configure a host for hourly logrotate jobs.
#
# ensure - The desired state of hourly logrotate support.  Valid values are
#          'absent' and 'present' (default: 'present').
#
# Examples
#
#   # Set up hourly logrotate jobs
#   class { 'logrotate':
#     manage_cron_hourly => true,
#   }
#
#   # Remove hourly logrotate job support
#   class { 'logrotate':
#     manage_cron_hourly => true,
#     ensure_cron_hourly => absent,
#   }
class logrotate::hourly (
) {
  assert_private()

  $dir_ensure = $logrotate::ensure_cron_hourly ? {
    'absent'  => $logrotate::ensure_cron_hourly,
    'present' => 'directory'
  }

  file { "${logrotate::rules_configdir}/hourly":
    ensure => $dir_ensure,
    owner  => 'root',
    group  => 0,
    mode   => $logrotate::rules_configdir_mode,
  }

  if $logrotate::manage_cron_hourly {
    logrotate::cron { 'hourly':
      ensure  => $logrotate::ensure_cron_hourly,
      require => File["${logrotate::rules_configdir}/hourly"],
    }
  }
}
