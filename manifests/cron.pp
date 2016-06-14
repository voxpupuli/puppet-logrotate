#
define logrotate::cron (
  $ensure = 'present'
) {
  $script_path = $osfamily ? {
    'FreeBSD' => "/usr/local/bin/logrotate.${name}.sh",
    default   => "/etc/cron.${name}/logrotate",
  }

  file { "${script_path}":
    ensure  => $ensure,
    owner   => $logrotate::root_user,
    group   => $logrotate::root_group,
    mode    => '0555',
    source  => "puppet:///modules/logrotate/etc/cron.${name}/logrotate",
  }
}
