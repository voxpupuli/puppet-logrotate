#
define logrotate::cron (
  $ensure = 'present'
) {
  $script_path = $::osfamily ? {
    'FreeBSD' => "/usr/local/bin/logrotate.${name}.sh",
    default   => "/etc/cron.${name}/logrotate",
  }

  $logrotate_path = $::logrotate::logrotate_bin

  if $name == 'hourly' {
    $logrotate_arg = "${::logrotate::rules_configdir}/hourly"
  } else {
    $logrotate_arg = $::logrotate::logrotate_conf
  }

  # FreeBSD does not have /etc/cron.daily, so we need to have Puppet maintain
  # a crontab entry
  if $::osfamily == 'FreeBSD' {
    if $name == 'hourly' {
      $cron_hour   = '*'
      $cron_minute = $::logrotate::cron_hourly_minute
    } else {
      $cron_hour   = $::logrotate::cron_daily_hour
      $cron_minute = $::logrotate::cron_daily_minute
    }

    cron { "logrotate_${name}":
      minute  => $cron_minute,
      hour    => $cron_hour,
      command => $script_path,
      user    => 'root',
    }
  }

  file { $script_path:
    ensure  => $ensure,
    owner   => $logrotate::root_user,
    group   => $logrotate::root_group,
    mode    => '0555',
    content => template('logrotate/etc/cron/logrotate.erb'),
  }
}
