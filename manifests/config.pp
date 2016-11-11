# logrotate config
class logrotate::config{

  $manage_cron_daily = $::logrotate::manage_cron_daily
  $config            = $::logrotate::config

  $file_owner        = 'root'
  $file_group        = 'root'

  case $::osfamily {
    'RedHat' : {
      $file_mode = $::operatingsystemmajrelease ? {
        5       => '0755',
        default => '0700',
      }
      $dir_mode = '0644'
    }
    default: {
      $file_mode = '0555'
      $dir_mode  = '0755'
    }
  }

  # RedHat 7 running on IBM S390x architecture, the cron.daily script is different.
  if ($::osfamily == 'RedHat') and ($::operatingsystemmajrelease == '7') and ($::architecture == 's390x') {
    $cron_daily_script = 'logrotate.s390x'
  } else {
    $cron_daily_script = 'logrotate'
  }

  file{'/etc/logrotate.d':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => $dir_mode,
  }

  if $manage_cron_daily {
    file{'/etc/cron.daily/logrotate':
      ensure => file,
      owner  => $file_owner,
      group  => $file_group,
      mode   => $file_mode,
      source => "puppet:///modules/logrotate/etc/cron.daily/${cron_daily_script}",
    }
  }

  if is_hash($config) {
    $custom_config = {'/etc/logrotate.conf' => $config}
    create_resources('logrotate::conf', $custom_config)
  }

}
