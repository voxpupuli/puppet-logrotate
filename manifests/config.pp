# logrotate config
class logrotate::config{

  $manage_cron_daily = $::logrotate::manage_cron_daily
  $config            = $::logrotate::config

  file{ $::logrotate::rules_configdir:
    ensure => directory,
    owner  => $logrotate::root_user,
    group  => $logrotate::root_group,
    mode   => '0755',
  }

  if $manage_cron_daily {
    logrotate::cron { 'daily': }
  }

  if is_hash($config) {
    $custom_config = {"${logrotate::logrotate_conf}" => $config}
    create_resources('logrotate::conf', $custom_config)
  }

}
