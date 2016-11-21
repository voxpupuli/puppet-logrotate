# logrotate config
class logrotate::config{

  $manage_cron_daily = $::logrotate::manage_cron_daily
  $config            = $::logrotate::config

  file{'/etc/logrotate.d':
    ensure => directory,
    owner  => 'root',
    group  => $::logrotate::rootgroup,
    mode   => '0755',
  }

  if $manage_cron_daily {
    file{'/etc/cron.daily/logrotate':
      ensure => file,
      owner  => 'root',
      group  => $::logrotate::rootgroup,
      mode   => '0555',
      source => 'puppet:///modules/logrotate/etc/cron.daily/logrotate',
    }
  }

  if is_hash($config) {
    $custom_config = {'/etc/logrotate.conf' => $config}
    create_resources('logrotate::conf', $custom_config)
  }

}
