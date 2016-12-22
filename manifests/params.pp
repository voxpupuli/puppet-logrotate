class logrotate::params {

  $config_file = '/etc/logrotate.conf'

  case $::osfamily {
    'Debian': {
      $default_su_group = versioncmp($::operatingsystemmajrelease, '14.00') ? {
        1         => 'syslog',
        default   => undef
      }
      $conf_params = {
        su_group => $default_su_group
      }
    }
    'Gentoo': {
      $conf_params = {
        dateext  => true,
        compress => true,
        ifempty  => false,
        mail     => false,
        olddir   => false,
      }
    }
    default: {
      $conf_params = { }
    }
  }

}