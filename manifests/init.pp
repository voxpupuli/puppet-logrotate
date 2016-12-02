#
class logrotate (
  Enum[
    'present',
    'absent',
    'latest']      $ensure            = present,
  Boolean          $hieramerge        = false,
  Boolean          $manage_cron_daily = true,
  String           $package           = 'logrotate',
  Hash             $rules             = { },
  Optional[String] $config            = undef,
) inherits logrotate::params {

  include ::logrotate::install
  include ::logrotate::config
  include ::logrotate::rules
  include ::logrotate::defaults

  anchor { 'logrotate_begin': } ->
  Class['::logrotate::install']->
  Class['::logrotate::config']->
  Class['::logrotate::rules']->
  Class['::logrotate::defaults']->
  anchor { 'logrotate_end': }

}
