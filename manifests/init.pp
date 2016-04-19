#
class logrotate (
  $ensure            = present,
  $hieramerge        = false,
  $manage_cron_daily = true,
  $package           = 'logrotate',
  $rules             = {},
  $config            = undef,
  $selinux           = false,
) {

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
