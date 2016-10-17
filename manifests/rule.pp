# Public: Configure logrotate to rotate a logfile.
#
# namevar         - The String name of the rule.
# path            - The path String to the logfile(s) to be rotated.
# ensure          - The desired state of the logrotate rule as a String.  Valid
#                   values are 'absent' and 'present' (default: 'present').
# compress        - A Boolean value specifying whether the rotated logs should
#                   be compressed (optional).
# compresscmd     - The command String that should be executed to compress the
#                   rotated logs (optional).
# compressext     - The extention String to be appended to the rotated log files
#                   after they have been compressed (optional).
# compressoptions - A String of command line options to be passed to the
#                   compression program specified in `compresscmd` (optional).
# copy            - A Boolean specifying whether logrotate should just take a
#                   copy of the log file and not touch the original (optional).
# copytruncate    - A Boolean specifying whether logrotate should truncate the
#                   original log file after taking a copy (optional).
# create          - A Boolean specifying whether logrotate should create a new
#                   log file immediately after rotation (optional).
# create_mode     - An octal mode String logrotate should apply to the newly
#                   created log file if create => true (optional).
# create_owner    - A username String that logrotate should set the owner of the
#                   newly created log file to if create => true (optional).
# create_group    - A String group name that logrotate should apply to the newly
#                   created log file if create => true (optional).
# dateext         - A Boolean specifying whether rotated log files should be
#                   archived by adding a date extension rather just a number
#                   (optional).
# dateformat      - The format String to be used for `dateext` (optional).
#                   Valid specifiers are '%Y', '%m', '%d' and '%s'.
# delaycompress   - A Boolean specifying whether compression of the rotated
#                   log file should be delayed until the next logrotate run
#                   (optional).
# extension       - Log files with this extension String are allowed to keep it
#                   after rotation (optional).
# ifempty         - A Boolean specifying whether the log file should be rotated
#                   even if it is empty (optional).
# mail            - The email address String that logs that are about to be
#                   rotated out of existence are emailed to (optional).
# mailfirst       - A Boolean that when used with `mail` has logrotate email the
#                   just rotated file rather than the about to expire file
#                   (optional).
# maillast        - A Boolean that when used with `mail` has logrotate email the
#                   about to expire file rather than the just rotated file
#                   (optional).
# maxage          - The Integer maximum number of days that a rotated log file
#                   can stay on the system (optional).
# minsize         - The String minimum size a log file must be to be rotated,
#                   but not before the scheduled rotation time (optional).
#                   The default units are bytes, append k, M or G for kilobytes,
#                   megabytes and gigabytes respectively.
# maxsize         - The String maximum size a log file may be to be rotated;
#                   When maxsize is used, both the size and timestamp of a log
#                   file are considered for rotation.
#                   The default units are bytes, append k, M or G for kilobytes,
#                   megabytes and gigabytes respectively.
# missingok       - A Boolean specifying whether logrotate should ignore missing
#                   log files or issue an error (optional).
# olddir          - A String path to a directory that rotated logs should be
#                   moved to (optional).
# postrotate      - A command String or an Array of Strings that should be
#                   executed by /bin/sh after the log file is rotated
#                   optional).
# prerotate       - A command String or an Array of Strings that should be
#                   executed by /bin/sh before the log file is rotated and
#                   only if it will be rotated (optional).
# firstaction     - A command String or an Array of Strings that should be
#                   executed by /bin/sh once before all log files that match
#                   the wildcard pattern are rotated (optional).
# lastaction      - A command String or an Array of Strings that should be
#                   executed by /bin/sh once after all the log files that match
#                   the wildcard pattern are rotated (optional).
# rotate          - The Integer number of rotated log files to keep on disk
#                   (optional).
# rotate_every    - How often the log files should be rotated as a String.
#                   Valid values are 'day', 'week', 'month' and 'year'
#                   (optional).
# size            - The String size a log file has to reach before it will be
#                   rotated (optional).  The default units are bytes, append k,
#                   M or G for kilobytes, megabytes or gigabytes respectively.
# sharedscripts   - A Boolean specifying whether logrotate should run the
#                   postrotate and prerotate scripts for each matching file or
#                   just once (optional).
# shred           - A Boolean specifying whether logs should be deleted with
#                   shred instead of unlink (optional).
# shredcycles     - The Integer number of times shred should overwrite log files
#                   before unlinking them (optional).
# start           - The Integer number to be used as the base for the extensions
#                   appended to the rotated log files (optional).
# su              - A Boolean specifying whether logrotate should rotate under
#                   the specific su_owner and su_group instead of the default.
#                   First available in logrotate 3.8.0. (optional)
# su_owner        - A username String that logrotate should use to rotate a
#                   log file set instead of using the default if
#                   su => true (optional).
# su_group        - A String group name that logrotate should use to rotate a
#                   log file set instead of using the default if
#                   su => true (optional).
# uncompresscmd   - The String command to be used to uncompress log files
#                   (optional).
#
# Examples
#
#   # Rotate /var/log/syslog daily and keep 7 days worth of compressed logs.
#   logrotate::rule { 'messages':
#     path         => '/var/log/messages',
#     copytruncate => true,
#     missingok    => true,
#     rotate_every => 'day',
#     rotate       => 7,
#     compress     => true,
#     ifempty      => true,
#   }
#
#   # Rotate /var/log/nginx/access_log weekly and keep 3 weeks of logs
#   logrotate::rule { 'nginx_access_log':
#     path         => '/var/log/nginx/access_log',
#     missingok    => true,
#     rotate_every => 'week',
#     rotate       => 3,
#     postrotate   => '/etc/init.d/nginx restart',
#   }
define logrotate::rule(
                        $path            = 'UNDEFINED',
                        $ensure          = 'present',
                        $compress        = 'UNDEFINED',
                        $compresscmd     = 'UNDEFINED',
                        $compressext     = 'UNDEFINED',
                        $compressoptions = 'UNDEFINED',
                        $copy            = 'UNDEFINED',
                        $copytruncate    = 'UNDEFINED',
                        $create          = 'UNDEFINED',
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
                        $minsize         = 'UNDEFINED',
                        $maxsize         = 'UNDEFINED',
                        $missingok       = 'UNDEFINED',
                        $olddir          = 'UNDEFINED',
                        $postrotate      = 'UNDEFINED',
                        $prerotate       = 'UNDEFINED',
                        $firstaction     = 'UNDEFINED',
                        $lastaction      = 'UNDEFINED',
                        $rotate          = 'UNDEFINED',
                        $rotate_every    = 'UNDEFINED',
                        $size            = 'UNDEFINED',
                        $sharedscripts   = 'UNDEFINED',
                        $shred           = 'UNDEFINED',
                        $shredcycles     = 'UNDEFINED',
                        $start           = 'UNDEFINED',
                        $su              = 'UNDEFINED',
                        $su_owner        = 'UNDEFINED',
                        $su_group        = 'UNDEFINED',
                        $uncompresscmd   = 'UNDEFINED'
                        ) {

  #############################################################################
  # SANITY CHECK VALUES

  validate_re($name, '^[a-zA-Z0-9\._-]+$', "Logrotate::Rule[${name}]: namevar must be alphanumeric")

  case $ensure {
    'present': {
      if $path == 'UNDEFINED' {
        fail("Logrotate::Rule[${name}]: path not specified")
      }
    }
    'absent': {}
    default: {
      fail("Logrotate::Rule[${name}]: invalid ensure value")
    }
  }

  case $compress {
    'UNDEFINED': {}
    true: { $sane_compress = 'compress' }
    false: { $sane_compress = 'nocompress' }
    default: {
      fail("Logrotate::Rule[${name}]: compress must be a boolean")
    }
  }

  case $copy {
    'UNDEFINED': {}
    true: { $sane_copy = 'copy' }
    false: { $sane_copy = 'nocopy' }
    default: {
      fail("Logrotate::Rule[${name}]: copy must be a boolean")
    }
  }

  case $copytruncate {
    'UNDEFINED': {}
    true: { $sane_copytruncate = 'copytruncate' }
    false: { $sane_copytruncate = 'nocopytruncate' }
    default: {
      fail("Logrotate::Rule[${name}]: copytruncate must be a boolean")
    }
  }

  case $create {
    'UNDEFINED': {}
    true: { $sane_create = 'create' }
    false: { $sane_create = 'nocreate' }
    default: {
      fail("Logrotate::Rule[${name}]: create must be a boolean")
    }
  }

  case $delaycompress {
    'UNDEFINED': {}
    true: { $sane_delaycompress = 'delaycompress' }
    false: { $sane_delaycompress = 'nodelaycompress' }
    default: {
      fail("Logrotate::Rule[${name}]: delaycompress must be a boolean")
    }
  }

  case $dateext {
    'UNDEFINED': {}
    true: { $sane_dateext = 'dateext' }
    false: { $sane_dateext = 'nodateext' }
    default: {
      fail("Logrotate::Rule[${name}]: dateext must be a boolean")
    }
  }

  case $mail {
    'UNDEFINED': {}
    false: { $sane_mail = 'nomail' }
    default: {
      $sane_mail = "mail ${mail}"
    }
  }

  case $missingok {
    'UNDEFINED': {}
    true: { $sane_missingok = 'missingok' }
    false: { $sane_missingok = 'nomissingok' }
    default: {
      fail("Logrotate::Rule[${name}]: missingok must be a boolean")
    }
  }

  case $olddir {
    'UNDEFINED': {}
    false: { $sane_olddir = 'noolddir' }
    default: {
      $sane_olddir = "olddir ${olddir}"
    }
  }

  case $sharedscripts {
    'UNDEFINED': {}
    true: { $sane_sharedscripts = 'sharedscripts' }
    false: { $sane_sharedscripts = 'nosharedscripts' }
    default: {
      fail("Logrotate::Rule[${name}]: sharedscripts must be a boolean")
    }
  }

  case $shred {
    'UNDEFINED': {}
    true: { $sane_shred = 'shred' }
    false: { $sane_shred = 'noshred' }
    default: {
      fail("Logrotate::Rule[${name}]: shred must be a boolean")
    }
  }

  case $ifempty {
    'UNDEFINED': {}
    true: { $sane_ifempty = 'ifempty' }
    false: { $sane_ifempty = 'notifempty' }
    default: {
      fail("Logrotate::Rule[${name}]: ifempty must be a boolean")
    }
  }

  case $rotate_every {
    'UNDEFINED': {}
    'hour', 'hourly': {}
    'day': { $sane_rotate_every = 'daily' }
    'week': { $sane_rotate_every = 'weekly' }
    'month': { $sane_rotate_every = 'monthly' }
    'year': { $sane_rotate_every = 'yearly' }
    'daily', 'weekly','monthly','yearly': { $sane_rotate_every = $rotate_every }
    default: {
      fail("Logrotate::Rule[${name}]: invalid rotate_every value")
    }
  }

  # Interpolate any variables that might be integers into strings for futer parser compatibility
  # Add an arbitrary character to the string to stop puppet-lint complaining
  # Any better ideas greatfully received
  validate_re("X${maxage}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: maxage must be an integer")
  validate_re("X${minsize}", ['^XUNDEFINED$', '^X\d+[kMG]?$'], "Logrotate::Conf[${name}]: minsize must match /\\d+[kMG]?/")
  validate_re("X${maxsize}", ['^XUNDEFINED$', '^X\d+[kMG]?$'], "Logrotate::Conf[${name}]: maxsize must match /\\d+[kMG]?/")
  validate_re("X${rotate}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: rotate must be an integer")
  validate_re("X${size}", ['^XUNDEFINED$', '^X\d+[kMG]?$'], "Logrotate::Conf[${name}]: size must match /\\d+[kMG]?/")
  validate_re("X${shredcycles}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: shredcycles must be an integer")
  validate_re("X${start}", ['^XUNDEFINED$', '^X\d+$'], "Logrotate::Conf[${name}]: start must be an integer")

  case $su {
    'UNDEFINED',false: {}
    true: { $sane_su = 'su' }
    default: {
      fail("Logrotate::Rule[${name}]: su must be a boolean")
    }
  }

  case $mailfirst {
    'UNDEFINED',false: {}
    true: {
      if $maillast == true {
        fail("Logrotate::Rule[${name}]: Can't set both mailfirst and maillast")
      }

      $sane_mailfirst = 'mailfirst'
    }
    default: {
      fail("Logrotate::Rule[${name}]: mailfirst must be a boolean")
    }
  }

  case $maillast {
    'UNDEFINED',false: {}
    true: {
      $sane_maillast = 'maillast'
    }
    default: {
      fail("Logrotate::Rule[${name}]: maillast must be a boolean")
    }
  }

  if ($create_group != 'UNDEFINED') and ($create_owner == 'UNDEFINED') {
    fail("Logrotate::Rule[${name}]: create_group requires create_owner")
  }

  if ($create_owner != 'UNDEFINED') and ($create_mode == 'UNDEFINED') {
    fail("Logrotate::Rule[${name}]: create_owner requires create_mode")
  }

  if ($create_mode != 'UNDEFINED') and ($create != true) {
    fail("Logrotate::Rule[${name}]: create_mode requires create")
  }

  # su requires at least su_owner
  if ($su == true) and ($su_owner == 'UNDEFINED') {
    fail("Logrotate::Rule[${name}]: su requires su_owner and optional su_group")
  }

  # su should be set to true if su_owner exists
  if ($su_owner != 'UNDEFINED') and ($su != true) {
    fail("Logrotate::Rule[${name}]: su_owner requires su")
  }

  #############################################################################
  #

  include ::logrotate

  case $rotate_every {
    'hour', 'hourly': {
      include ::logrotate::hourly
      $rule_path = "${logrotate::rules_configdir}/hourly/${name}"

      file { "${logrotate::rules_configdir}/${name}":
        ensure => absent,
      }
    }
    default: {
      $rule_path = "${logrotate::rules_configdir}/${name}"

      file { "${logrotate::rules_configdir}/hourly/${name}":
        ensure => absent,
      }
    }
  }

  file { $rule_path:
    ensure  => $ensure,
    owner   => $logrotate::root_user,
    group   => $logrotate::root_group,
    mode    => '0444',
    content => template('logrotate/etc/logrotate.d/rule.erb'),
    require => Class['::logrotate::config'],
  }
}
