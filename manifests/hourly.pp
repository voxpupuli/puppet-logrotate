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
  Enum['present','absent'] $ensure='present'
) {

  $dir_ensure = $ensure ? {
    'absent'  => $ensure,
    'present' => 'directory'
  }

  file { '/etc/logrotate.d/hourly':
    ensure => $dir_ensure,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
  file { '/etc/cron.hourly/logrotate':
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0555',
    source  => 'puppet:///modules/logrotate/etc/cron.hourly/logrotate',
    require => [ File['/etc/logrotate.d/hourly'], Package['logrotate'], ],
  }
}
