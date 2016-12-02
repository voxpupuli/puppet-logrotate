# make sure logrotate is installed
class logrotate::install{

  assert_private()

  package { $::logrotate::package:
    ensure => $::logrotate::ensure,
  }

}