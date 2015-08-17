#
class logrotate (
  $ensure            = 'latest',
  $hieramerge        = false,
  $manage_cron_daily = true,
  $package           = 'logrotate',
  $rules             = {},
  $config            = undef,
) {

  case $ensure {
    'latest': { $_ensure = 'latest' }
    false,'absent': { $_ensure = 'absent' }
    default: { $_ensure = 'present' }
  }

  package { $package:
    ensure => $_ensure,
  }

  File {
    owner   => 'root',
    group   => 'root',
    require => Package[$package],
  }

  file {'/etc/logrotate.d':
      ensure => directory,
      mode   => '0755',
  }
  if $manage_cron_daily {
    file {'/etc/cron.daily/logrotate':
        ensure => file,
        mode   => '0555',
        source => 'puppet:///modules/logrotate/etc/cron.daily/logrotate',
    }
  }

  if is_hash($config) {
    $custom_config = {'/etc/logrotate.conf' => $config}
    create_resources('logrotate::conf', $custom_config)
  }

  include ::logrotate::defaults

  if $hieramerge {
    $_rules = hiera_hash('logrotate::rules', $rules)
  } else {
    $_rules = $rules
  }

  create_resources('logrotate::rule', $_rules)

}
