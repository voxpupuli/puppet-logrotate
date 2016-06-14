#
class logrotate::params {
  $configdir = $osfamily ? {
    'FreeBSD' => '/usr/local/etc',
    default   => '/etc',
  }

  $logrotate_conf = "${configdir}/logrotate.conf"

  $rules_configdir = "${configdir}/logrotate.d"

  $root_user = 'root'

  $root_group = $osfamily ? {
    'FreeBSD' => 'wheel',
    default   => 'root',
  }
}
