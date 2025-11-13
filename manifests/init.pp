# @summary Install and configure logrotate
#
# @param ensure
#   Desired installation state for the logrotate package
#
# @param manage_cron_daily
#   Manage logrotate daily cron file
#
# @param manage_cron_hourly
#   Manage logrotate hourly cron file
#
# @param ensure_cron_daily
#   Ensure logrotate daily cron file is present/absent
#
# @param ensure_cron_hourly
#   Ensure logrotate hourly cron file is present/absent
#
# @param manage_systemd_timer
#   Manage logrotate systemd timer
#
# @param ensure_systemd_timer
#   Ensure logrotate systemd timer is present/absent
#
# @param ensure_systemd_timer_hourly
#   Ensure logrotate systemd hourly timer is present/absent
#
# @param create_base_rules
#   Create base rules (for example btmp, wtmp)
#
# @param purge_configdir
#   Purge logrotate files not managed by the module.
#
# @param package
#   Logrotate package name.
#
# @param rules
#   Hash of logrotate logrotate::rule rules
#
# @param config
#   Hash of default config values for logrotate
#
# @param cron_daily_hour
#   Hour at which daily logrotate cron is executed
#
# @param cron_daily_minute
#   Minute at which daily logrotate cron is executed
#
# @param cron_hourly_minute
#   Minute at which hourly logrotate cron is executed
#
# @param cron_file_mode
#   Cron file permissions in numeric mode
#
# @param configdir
#   Path of config dir
#
# @param logrotate_bin
#   Path of logrotate binary
#
# @param logrotate_conf
#   Path of logrotate.conf
#
# @param logrotate_conf_mode
#   Path of `logrotate.conf`
#
# @param manage_package
#   Whether to manage logrtotate package
#
# @param rules_configdir
#    Path in which logrotate rules are created.
#
# @param rules_configdir_mode
#   Logrotate rules folder permissions in numeric mode.
#
# @param root_user
#   Name of root user.
#
# @param root_group
#   Name of root group.
#
# @param logrotate_args
#   Arguments passed to logrotate.
#
# @param cron_always_output
#   Do not discard cron output when there is no error.
#
class logrotate (
  String $ensure                             = present,
  Boolean $manage_cron_daily                 = true,
  Boolean $manage_cron_hourly                = true,
  Enum[present,absent] $ensure_cron_daily    = 'present',
  Enum[present,absent] $ensure_cron_hourly   = 'present',
  Boolean $manage_systemd_timer              = false,
  Enum[present,absent] $ensure_systemd_timer = 'absent',
  Enum[present,absent] $ensure_systemd_timer_hourly = 'absent',
  Boolean $create_base_rules                 = true,
  Boolean $purge_configdir                   = false,
  String $package                            = 'logrotate',
  Hash $rules                                = {},
  Optional[Hash] $config                     = undef,
  Integer[0,23] $cron_daily_hour             = $logrotate::params::cron_daily_hour,
  Integer[0,59] $cron_daily_minute           = $logrotate::params::cron_daily_minute,
  Integer[0,59] $cron_hourly_minute          = $logrotate::params::cron_hourly_minute,
  Stdlib::Filemode $cron_file_mode           = $logrotate::params::cron_file_mode,
  String $configdir                          = $logrotate::params::configdir,
  String $logrotate_bin                      = $logrotate::params::logrotate_bin,
  String $logrotate_conf                     = $logrotate::params::logrotate_conf,
  Stdlib::Filemode $logrotate_conf_mode      = $logrotate::params::logrotate_conf_mode,
  Boolean $manage_package                    = $logrotate::params::manage_package,
  String $rules_configdir                    = $logrotate::params::rules_configdir,
  Stdlib::Filemode $rules_configdir_mode     = $logrotate::params::rules_configdir_mode,
  String $root_user                          = $logrotate::params::root_user,
  String $root_group                         = $logrotate::params::root_group,
  Array[String[1]] $logrotate_args           = [],
  Boolean $cron_always_output                = false,
) inherits logrotate::params {
  contain logrotate::install
  contain logrotate::config
  contain logrotate::rules
  contain logrotate::defaults
  contain logrotate::hourly

  Class['logrotate::install']
  -> Class['logrotate::config']
  -> Class['logrotate::rules']
  -> Class['logrotate::defaults']
}
