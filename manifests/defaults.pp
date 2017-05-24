# apply defaults
#
class logrotate::defaults{

  case $::osfamily {
    'Debian': {

      if !defined( Logrotate::Conf[$logrotate::logrotate_conf] ) {
        if versioncmp($::lsbdistrelease, '14.04') >= 0 {
          logrotate::conf {$logrotate::logrotate_conf:
            su_group => 'syslog',
          }
        } else {
          logrotate::conf {$logrotate::logrotate_conf: }
        }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'month',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => '1',
      }

      if !defined( Logrotate::Rule['wtmp'] ) {
        logrotate::rule { 'wtmp':
            path        => '/var/log/wtmp',
            create_mode => '0664',
        }
      }
      if !defined( Logrotate::Rule['btmp'] ) {
        logrotate::rule { 'btmp':
          path        => '/var/log/btmp',
          create_mode => '0600',
        }
      }
    }
    'FreeBSD': {
      if !defined( Logrotate::Conf[$logrotate::logrotate_conf] ) {
        logrotate::conf {$logrotate::logrotate_conf:
          dateext  => true,
          compress => true,
          ifempty  => false,
          mail     => false,
          olddir   => false,
        }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'week',
        create       => true,
        create_owner => 'root',
        create_group => 'wheel',
        rotate       => '5',
      }

      if !defined( Logrotate::Rule['wtmp'] ) {
        logrotate::rule { 'wtmp':
            path        => '/var/log/wtmp',
            missingok   => false,
            create_mode => '0664',
            minsize     => '1M',
        }
      }
    }
    'Gentoo': {
      if !defined( Logrotate::Conf[$logrotate::logrotate_conf] ) {
        logrotate::conf {$logrotate::logrotate_conf:
          dateext  => true,
          compress => true,
          ifempty  => false,
          mail     => false,
          olddir   => false,
        }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'month',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => '1',
      }

      if !defined( Logrotate::Rule['wtmp'] ) {
        logrotate::rule { 'wtmp':
            path        => '/var/log/wtmp',
            missingok   => false,
            create_mode => '0664',
            minsize     => '1M',
        }
      }
      if !defined( Logrotate::Rule['btmp'] ) {
        logrotate::rule { 'btmp':
            path        => '/var/log/btmp',
            create_mode => '0600',
        }
      }
    }
    'RedHat': {
      if !defined( Logrotate::Conf[$logrotate::logrotate_conf] ) {
        logrotate::conf {$logrotate::logrotate_conf: }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'month',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => '1',
      }

      if !defined( Logrotate::Rule['wtmp'] ) {
        logrotate::rule { 'wtmp':
            path        => '/var/log/wtmp',
            create_mode => '0664',
            missingok   => false,
            minsize     => '1M',
        }
      }
      if !defined( Logrotate::Rule['btmp'] ) {
        logrotate::rule { 'btmp':
            path        => '/var/log/btmp',
            create_mode => '0600',
            minsize     => '1M',
        }
      }
    }
    'SuSE': {
      if !defined( Logrotate::Conf[$logrotate::logrotate_conf] ) {
        logrotate::conf {$logrotate::logrotate_conf: }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'month',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => '99',
        maxage       => '365',
        size         => '400k',
      }

      if !defined( Logrotate::Rule['wtmp'] ) {
        logrotate::rule { 'wtmp':
            path        => '/var/log/wtmp',
            create_mode => '0664',
            missingok   => false,
        }
      }

      if !defined( Logrotate::Rule['btmp'] ) {
        logrotate::rule { 'btmp':
            path         => '/var/log/btmp',
            create_mode  => '0600',
            create_group => 'root',
        }
      }
    }
    default: {
      if !defined( Logrotate::Conf[$logrotate::logrotate_conf] ) {
        logrotate::conf {$logrotate::logrotate_conf: }
      }
    }
  }
}
