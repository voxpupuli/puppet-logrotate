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
class logrotate::hourly (
  Enum['present','absent'] $ensure = 'present'
) {

  $dir_ensure = $ensure ? {
    'absent'  => $ensure,
    'present' => 'directory'
  }

  file { "${logrotate::rules_configdir}/hourly":
    ensure => $dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  logrotate::cron { 'hourly': }
}
