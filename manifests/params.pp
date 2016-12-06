class logrotate::params {

  case $::osfamily {
    'FreeBSD': { $configdir = '/usr/local/etc' }
    default: { $configdir = '/etc' }
  }

  $logrotate_conf = "${configdir}/logrotate.conf"
  $rules_configdir = "${configdir}/logrotate.d"
  $root_user = 'root'

  $root_group = $::osfamily ? {
    'FreeBSD' => 'wheel',
    default   => 'root',
  }
}
