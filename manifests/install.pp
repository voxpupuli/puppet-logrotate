# make sure logrotate is installed
class logrotate::install{

  $ensure  = $::logrotate::ensure
  $package = $::logrotate::package

  case $ensure {
    'latest': { $_ensure = 'latest' }
    false,'absent': { $_ensure = 'absent' }
    default: { $_ensure = 'present' }
  }

  if $_ensure == 'present' {
    # Make sure that we interact nicely with other modules
    # that may want to install the logrotate package.
    ensure_packages($package)
  } else {
    # We have some special requirements for this package.
    # By not using ensure_packages here, we make sure that we
    # get an error if some other module also tries to
    # control this package.
    package { $package:
      ensure => $_ensure,
    }
  }

}