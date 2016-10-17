define logrotate::cron (
  $ensure = 'present'
) {

  case $::osfamily {
    'FreeBSD': { $script_path = "/usr/local/bin/logrotate.${name}.sh" }
    default: { $script_path = "/etc/cron.${name}/logrotate" }
  }

  file { $script_path:
    ensure => $ensure,
    owner  => $logrotate::root_user,
    group  => $logrotate::root_group,
    mode   => '0555',
    source => "puppet:///modules/logrotate/etc/cron.${name}/logrotate",
  }
}
