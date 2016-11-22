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
    case $::osfamily {
      'FreeBSD': {
        # FreeBSD does not have /etc/cron.daily
        cron { 'logrotate_daily':
          minute  => '1',
          hour    => '0',
          command => '/usr/local/sbin/logrotate /etc/logrotate.conf 2>&1',
          user    => 'root',
        }
      }
      default: {
        file{'/etc/cron.daily/logrotate':
          ensure => file,
          owner  => 'root',
          group  => $::logrotate::rootgroup,
          mode   => '0555',
          source => 'puppet:///modules/logrotate/etc/cron.daily/logrotate',
        }
      }
    }
  }

  if is_hash($config) {
    $custom_config = {'/etc/logrotate.conf' => $config}
    create_resources('logrotate::conf', $custom_config)
  }

}
