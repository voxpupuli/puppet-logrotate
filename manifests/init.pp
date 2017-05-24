#
class logrotate (
  $ensure             = present,
  $hieramerge         = false,
  $manage_cron_daily  = true,
  $package            = 'logrotate',
  $rules              = {},
  $config             = undef,
  $selinux            = false,
  $cron_daily_hour    = $logrotate::params::cron_daily_hour,
  $cron_daily_minute  = $logrotate::params::cron_daily_minute,
  $cron_hourly_minute = $logrotate::params::cron_hourly_minute,
  $configdir          = $logrotate::params::configdir,
  $logrotate_bin      = $logrotate::params::logrotate_bin,
  $logrotate_conf     = $logrotate::params::logrotate_conf,
  $rules_configdir    = $logrotate::params::rules_configdir,
  $root_user          = $logrotate::params::root_user,
  $root_group         = $logrotate::params::root_group,
) inherits ::logrotate::params {

  include ::logrotate::install
  include ::logrotate::config
  include ::logrotate::rules
  include ::logrotate::defaults

  if ($selinux) {
    include ::logrotate::selinux
  }

  anchor{'logrotate_begin':}->
  Class['::logrotate::install']->
  Class['::logrotate::config']->
  Class['::logrotate::rules']->
  Class['::logrotate::defaults']->
  anchor{'logrotate_end':}

}
