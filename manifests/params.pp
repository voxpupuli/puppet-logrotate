#
class logrotate::params {
  case $::osfamily {
    'FreeBSD': {
      $configdir     = '/usr/local/etc'
      $root_group    = 'wheel'
      $logrotate_bin = '/usr/local/sbin/logrotate'
    }
    default: {
      $configdir     = '/etc'
      $root_group    = 'root'
      $logrotate_bin = '/usr/sbin/logrotate'
    }
  }

  $cron_daily_hour    = '1'
  $cron_daily_minute  = '0'
  $cron_hourly_minute = '01'
  $logrotate_conf     = "${configdir}/logrotate.conf"
  $root_user          = 'root'
  $rules_configdir    = "${configdir}/logrotate.d"
}
