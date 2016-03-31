# apply defaults
#
class logrotate::defaults{

  case $::osfamily {
    'Debian': {

      if !defined( Logrotate::Conf['/etc/logrotate.conf'] ) {
        case $::lsbdistcodename {
          'trusty': {
            logrotate::conf {'/etc/logrotate.conf':
              su_group => 'syslog'
            }
          }
          default: {
            logrotate::conf {'/etc/logrotate.conf': }
          }
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

      if !defined(Logrotate::Rule['wtmp']) {
        logrotate::rule {
          'wtmp':
            path        => '/var/log/wtmp',
            create_mode => '0664',
            rotate      => '1',
        }
      }
      if !defined(Logrotate::Rule['btmp']) {
        logrotate::rule {
          'btmp':
            path        => '/var/log/btmp',
            create_mode => '0600',
        }
      }
    }
    'RedHat': {
      if !defined( Logrotate::Conf['/etc/logrotate.conf'] ) {
        logrotate::conf {'/etc/logrotate.conf': }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'month',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => '1',
      }

      if !defined(Logrotate::Rule['wtmp']) {
        logrotate::rule {
          'wtmp':
            path        => '/var/log/wtmp',
            create_mode => '0664',
            missingok   => false,
            minsize     => '1M';
        }
      }
      if !defined(Logrotate::Rule['btmp']) {
        logrotate::rule {
          'btmp':
            path        => '/var/log/btmp',
            create_mode => '0600',
            minsize     => '1M';
        }
      }
    }
    'SuSE': {
      if !defined( Logrotate::Conf['/etc/logrotate.conf'] ) {
        logrotate::conf {'/etc/logrotate.conf': }
      }

      Logrotate::Rule {
        missingok    => true,
        rotate_every => 'month',
        create       => true,
        create_owner => 'root',
        create_group => 'utmp',
        rotate       => '99',
        maxage       => '365',
        size         => '400k'
      }

      if !defined(Logrotate::Rule['wtmp']) {
        logrotate::rule {
          'wtmp':
            path         => '/var/log/wtmp',
            create_mode  => '0664',
            missingok    => false;
        }
      }
      if !defined(Logrotate::Rule['btmp']) {
        logrotate::rule {
          'btmp':
            path         => '/var/log/btmp',
            create_mode  => '0600',
            create_group => 'root';
        }
      }
    }
    default: {
      if !defined( Logrotate::Conf['/etc/logrotate.conf'] ) {
        logrotate::conf {'/etc/logrotate.conf': }
      }
    }
  }
}
