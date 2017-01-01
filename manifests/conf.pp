# Internal: Install and configure logrotate defaults file, usually
#   /etc/logrotate.conf
#
# see logrotate::Conf for description of options.
#
# Examples
#
#   logrotate::conf{'/etc/logrotate.conf':}
#
define logrotate::conf (
    $ensure          = 'present',
    $compress        = 'UNDEFINED',
    $compresscmd     = 'UNDEFINED',
    $compressext     = 'UNDEFINED',
    $compressoptions = 'UNDEFINED',
    $copy            = 'UNDEFINED',
    $copytruncate    = 'UNDEFINED',
    $create          = true,
    $create_mode     = 'UNDEFINED',
    $create_owner    = 'UNDEFINED',
    $create_group    = 'UNDEFINED',
    $dateext         = 'UNDEFINED',
    $dateformat      = 'UNDEFINED',
    $delaycompress   = 'UNDEFINED',
    $extension       = 'UNDEFINED',
    $ifempty         = 'UNDEFINED',
    $mail            = 'UNDEFINED',
    $mailfirst       = 'UNDEFINED',
    $maillast        = 'UNDEFINED',
    $maxage          = 'UNDEFINED',
    $maxsize         = 'UNDEFINED',
    $minsize         = 'UNDEFINED',
    $missingok       = 'UNDEFINED',
    $olddir          = 'UNDEFINED',
    $postrotate      = 'UNDEFINED',
    $prerotate       = 'UNDEFINED',
    $firstaction     = 'UNDEFINED',
    $lastaction      = 'UNDEFINED',
    $rotate          = '4',
    $rotate_every    = 'weekly',
    $size            = 'UNDEFINED',
    $sharedscripts   = 'UNDEFINED',
    $shred           = 'UNDEFINED',
    $shredcycles     = 'UNDEFINED',
    $start           = 'UNDEFINED',
    $su_user         = 'UNDEFINED',
    $su_group        = 'UNDEFINED',
    $uncompresscmd   = 'UNDEFINED'
) {

#############################################################################
# SANITY CHECK VALUES

  validate_re($name, '^[a-zA-Z0-9\._\/-]+$', "Logrotate::Conf[${name}]: namevar must be alphanumeric")
  validate_re($ensure, '^(?:absent|present|file)$', "Logrotate::Conf[${name}]: invalid ensure value")

  case $compress {
    'UNDEFINED': {}
    true: { $_compress = 'compress' }
    false: { $_compress = 'nocompress' }
    default: {
      fail("Logrotate::Conf[${name}]: compress must be a boolean")
    }
  }

  case $copy {
    'UNDEFINED': {}
    true: { $_copy = 'copy' }
    false: { $_copy = 'nocopy' }
    default: {
      fail("Logrotate::Conf[${name}]: copy must be a boolean")
    }
  }

  case $copytruncate {
    'UNDEFINED': {}
    true: { $_copytruncate = 'copytruncate' }
    false: { $_copytruncate = 'nocopytruncate' }
    default: {
      fail("Logrotate::Conf[${name}]: copytruncate must be a boolean")
    }
  }

  case $create {
    'UNDEFINED': {}
    true: { $_create = 'create' }
    false: { $_create = 'nocreate' }
    default: {
      fail("Logrotate::Conf[${name}]: create must be a boolean")
    }
  }

  case $delaycompress {
    'UNDEFINED': {}
    true: { $_delaycompress = 'delaycompress' }
    false: { $_delaycompress = 'nodelaycompress' }
    default: {
      fail("Logrotate::Conf[${name}]: delaycompress must be a boolean")
    }
  }

  case $dateext {
    'UNDEFINED': {}
    true: { $_dateext = 'dateext' }
    false: { $_dateext = 'nodateext' }
    default: {
      fail("Logrotate::Conf[${name}]: dateext must be a boolean")
    }
  }

  case $mail {
    'UNDEFINED': {}
    false: { $_mail = 'nomail' }
    default: {
      $_mail = "mail ${mail}"
    }
  }

  case $missingok {
    'UNDEFINED': {}
    true: { $_missingok = 'missingok' }
    false: { $_missingok = 'nomissingok' }
    default: {
      fail("Logrotate::Conf[${name}]: missingok must be a boolean")
    }
  }

  case $olddir {
    'UNDEFINED': {}
    false: { $_olddir = 'noolddir' }
    default: {
      $_olddir = "olddir ${olddir}"
    }
  }

  case $sharedscripts {
    'UNDEFINED': {}
    true: { $_sharedscripts = 'sharedscripts' }
    false: { $_sharedscripts = 'nosharedscripts' }
    default: {
      fail("Logrotate::Conf[${name}]: sharedscripts must be a boolean")
    }
  }

  case $shred {
    'UNDEFINED': {}
    true: { $_shred = 'shred' }
    false: { $_shred = 'noshred' }
    default: {
      fail("Logrotate::Conf[${name}]: shred must be a boolean")
    }
  }

  case $ifempty {
    'UNDEFINED': {}
    true: { $_ifempty = 'ifempty' }
    false: { $_ifempty = 'notifempty' }
    default: {
      fail("Logrotate::Conf[${name}]: ifempty must be a boolean")
    }
  }

  case $rotate_every {
    'UNDEFINED': {}
    'day': { $_rotate_every = 'daily' }
    'week': { $_rotate_every = 'weekly' }
    'month': { $_rotate_every = 'monthly' }
    'year': { $_rotate_every = 'yearly' }
    'daily', 'weekly','monthly','yearly': { $_rotate_every = $rotate_every }
    default: {
      fail("Logrotate::Conf[${name}]: invalid rotate_every value")
    }
  }

  # Interpolate any variables that might be integers into strings for futer parser compatibility
  # Add an arbitrary character to the string to stop puppet-lint complaining
  # Any better ideas greatfully received
  validate_re("X${maxage}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: maxage must be an integer")
  validate_re("X${maxsize}", ['^XUNDEFINED$', '^X\d+[kMG]?$'], "Logrotate::Conf[${name}]: maxsize must match /\\d+[kMG]?/")
  validate_re("X${minsize}", ['^XUNDEFINED$', '^X\d+[kMG]?$'], "Logrotate::Conf[${name}]: minsize must match /\\d+[kMG]?/")
  validate_re("X${rotate}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: rotate must be an integer")
  validate_re("X${size}", ['^XUNDEFINED$', '^X\d+[kMG]?$'], "Logrotate::Conf[${name}]: size must match /\\d+[kMG]?/")
  validate_re("X${shredcycles}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: shredcycles must be an integer")
  validate_re("X${start}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: start must be an integer")

  validate_re($su_user, ['^UNDEFINED$', '^[a-z_][a-z0-9_]{0,30}$'], "Logrotate::Conf[${name}]: su_user must match /^[a-z_][a-z0-9_]{0,30}$/")
  validate_re($su_group, ['^UNDEFINED$', '^[a-z_][a-z0-9_]{0,30}$'], "Logrotate::Conf[${name}]: su_group must match /^[a-z_][a-z0-9_]{0,30}$/")

  case $mailfirst {
    'UNDEFINED',false: {}
    true: {
      if $maillast == true {
        fail("Logrotate::Conf[${name}]: Can't set both mailfirst and maillast")
      }

      $_mailfirst = 'mailfirst'
    }
    default: {
      fail("Logrotate::Conf[${name}]: mailfirst must be a boolean")
    }
  }

  case $maillast {
    'UNDEFINED',false: {}
    true: {
      $_maillast = 'maillast'
    }
    default: {
      fail("Logrotate::Conf[${name}]: maillast must be a boolean")
    }
  }

  if ($su_user != 'UNDEFINED') and ($su_group == 'UNDEFINED') {
    $_su_user  = $_su_user
    $_su_group = 'root'
  } elsif ($su_user == 'UNDEFINED') and ($su_group != 'UNDEFINED') {
    $_su_user  = 'root'
    $_su_group = $su_group
  } else {
    $_su_user  = $su_user
    $_su_group = $su_group
  }

  if ($create_group != 'UNDEFINED') and ($create_owner == 'UNDEFINED') {
    fail("Logrotate::Conf[${name}]: create_group requires create_owner")
  }

  if ($create_owner != 'UNDEFINED') and ($create_mode == 'UNDEFINED') {
    fail("Logrotate::Conf[${name}]: create_owner requires create_mode")
  }

  if ($create_mode != 'UNDEFINED') and ($create != true) {
    fail("Logrotate::Conf[${name}]: create_mode requires create")
  }

#
####################################################################

  include ::logrotate

  file { $name:
      ensure  => $ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      content => template('logrotate/etc/logrotate.conf.erb'),
      require => Package['logrotate'],
  }
}
