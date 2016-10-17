class logrotate (
  $ensure            = present,
  $hieramerge        = false,
  $manage_cron_daily = true,
  $package           = 'logrotate',
  $rules             = {},
  $config            = undef,
  $configdir         = $logrotate::params::configdir,
  $logrotate_conf    = $logrotate::params::logrotate_conf,
  $rules_configdir   = $logrotate::params::rules_configdir,
  $root_user         = $logrotate::params::root_user,
  $root_group        = $logrotate::params::root_group,
) inherits ::logrotate::params {

  include ::logrotate::install
  include ::logrotate::config
  include ::logrotate::rules
  include ::logrotate::defaults

  anchor{'logrotate_begin':}->
  Class['::logrotate::install']->
  Class['::logrotate::config']->
  Class['::logrotate::rules']->
  Class['::logrotate::defaults']->
  anchor{'logrotate_end':}

}
