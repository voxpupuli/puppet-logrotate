# @summary Install and configure logrotate defaults file (usually /etc/logrotate.conf)
#
# @param path
#   Path of the logrotate.conf file to manage.
#
# @param ensure
#   Desired state for the logrotate.conf file.
#
# @param compress
#   A Boolean value specifying whether the rotated logs should be compressed.
#
# @param compresscmd
#   The command String that should be executed to compress the rotated logs.
#
# @param compressext
#   The extention String to be appended to the rotated log files after they have
#   been compressed.
#
# @param compressoptions
#   A String of command line options to be passed to the compression program
#   specified in `compresscmd`.
#
# @param copy
#   A Boolean specifying whether logrotate should just take a copy of the log
#   files and not touch the original.
#
# @param copytruncate
#   A Boolean specifying whether logrotate should truncate the original log file
#   after taking a copy.
#
# @param create
#   A Boolean specifying whether logrotate should create new log files
#   immediately after rotation.
#
# @param create_mode
#   An octal mode String logrotate should apply to the newly created log files
#   if create => true.
#
# @param create_owner
#   A username String that logrotate should set the owner of the newly created
#   log files to if create => true.
#
# @param create_group
#   A String group name that logrotate should apply to the newly created log
#   files if create => true.
#
# @param dateext
#   A Boolean specifying whether rotated log files should be archived by adding
#   a date extension rather just a number.
#
# @param dateformat
#   The format String to be used for `dateext` . Valid specifiers are '%Y',
#   '%m', '%d' and '%s'.
#
# @param dateyesterday
#   A Boolean specifying whether to use yesterday's date instead of today's date
#   to create the `dateext` extension.
#
# @param delaycompress
#   A Boolean specifying whether compression of the rotated log file should be
#   delayed until the next logrotate run.
#
# @param extension
#   Log files with this extension String are allowed to keep it after rotation.
#
# @param ifempty
#   A Boolean specifying whether the log file should be rotated even if it is
#   empty.
#
# @param mail
#   The email address String that logs that are about to be rotated out of
#   existence are emailed to.
#
# @param mail_when
#   When mail is configured, enable mailfirst (email the just rotated file
#   rather than the about to expire file) and/or maillast (email the about to
#   expire file rather than the just rotated file) behaviours.
#
# @param maxage
#   The Integer maximum number of days that a rotated log file can stay on the
#   system.
#
# @param minsize
#   The String minimum size a log file must be to be rotated, but not before the
#   scheduled rotation time. The default units are bytes, append k, M or G for
#   kilobytes, megabytes and gigabytes respectively.
#
# @param maxsize
#   The String maximum size a log file may be to be rotated; When maxsize is
#   used, both the size and timestamp of a log file are considered for rotation.
#   The default units are bytes, append k, M or G for kilobytes, megabytes and
#   gigabytes respectively.
#
# @param missingok
#   A Boolean specifying whether logrotate should ignore missing log files or
#   issue an error.
#
# @param olddir
#   A String path to a directory that rotated logs should be moved to.
#
# @param postrotate
#   A command String or an Array of Strings that should be executed by /bin/sh
#   after the log file is rotated optional).
#
# @param prerotate
#   A command String or an Array of Strings that should be executed by /bin/sh
#   before the log file is rotated and only if it will be rotated.
#
# @param firstaction
#   A command String or an Array of Strings that should be executed by /bin/sh
#   once before all log files that match the wildcard pattern are rotated.
#
# @param lastaction
#   A command String or an Array of Strings that should be executed by /bin/sh
#   once after all the log files that match the wildcard pattern are rotated.
#
# @param rotate
#   The Integer number of rotated log files to keep on disk.
#
# @param rotate_every
#   How often the log files should be rotated as a String. Valid values are
#   'day', 'week', 'month' and 'year'.
#
# @param size
#   The String size a log file has to reach before it will be rotated. The
#   default units are bytes, append k, M or G for kilobytes, megabytes or
#   gigabytes respectively.
#
# @param sharedscripts
#   A Boolean specifying whether logrotate should run the postrotate and
#   prerotate scripts for each matching file or just once.
#
# @param shred
#   A Boolean specifying whether logs should be deleted with shred instead of
#   unlink.
#
# @param shredcycles
#   The Integer number of times shred should overwrite log files before
#   unlinking them.
#
# @param start
#   The Integer number to be used as the base for the extensions appended to the
#   rotated log files.
#
# @param su
#   A Boolean specifying whether logrotate should rotate under the specific
#   su_user and su_group instead of the default. First available in logrotate
#   3.8.0.
#
# @param su_user
#   A String username that logrotate should use to rotate a log file set instead
#   of using the default if su => true.
#
# @param su_group
#   A String group name that logrotate should use to rotate a log file set
#   instead of using the default if su => true.
#
# @param uncompresscmd
#   The String command to be used to uncompress log files.
#
# @example Configure `/etc/logrotate.conf` with defaults + configure shred
#   logrotate::conf {
#      shred => true,
#    }
#
# @example Configure `/etc/logrotate.conf` to use zstd with non-default level
#   logrotate::conf {
#     compress        => true,
#     compresscmd     => '/usr/bin/zstd',
#     compressext     => '.zst',
#     compressoptions => '--compress -19',
#     uncompresscmd   => '/usr/bin/unzstd',
#   }
#
define logrotate::conf (
  Stdlib::Unixpath $path                             = $name,
  Enum['absent','present'] $ensure                   = 'present',
  Optional[Boolean] $compress                        = undef,
  Optional[String] $compresscmd                      = undef,
  Optional[String] $compressext                      = undef,
  Optional[String] $compressoptions                  = undef,
  Optional[Boolean] $copy                            = undef,
  Optional[Boolean] $copytruncate                    = undef,
  Boolean $create                                    = true,
  Optional[String] $create_mode                      = undef,
  Optional[String] $create_owner                     = undef,
  Optional[String] $create_group                     = undef,
  Optional[Boolean] $createolddir                    = undef,
  Optional[String] $createolddir_mode                = undef,
  Optional[String] $createolddir_owner               = undef,
  Optional[String] $createolddir_group               = undef,
  Optional[Boolean] $dateext                         = undef,
  Optional[String] $dateformat                       = undef,
  Optional[Boolean] $dateyesterday                   = undef,
  Optional[Boolean] $delaycompress                   = undef,
  Optional[String] $extension                        = undef,
  Optional[Variant[String,Array[String[1]]]] $include = undef,
  Optional[Boolean] $ifempty                         = undef,
  Optional[Variant[String,Boolean]] $mail            = undef,
  Optional[Enum['mailfirst', 'maillast']] $mail_when = undef,
  Optional[Integer] $maxage                          = undef,
  Optional[Logrotate::Size] $minsize                 = undef,
  Optional[Logrotate::Size] $maxsize                 = undef,
  Optional[Boolean] $missingok                       = undef,
  Optional[Variant[Boolean,String]] $olddir          = undef,
  Optional[String] $postrotate                       = undef,
  Optional[String] $prerotate                        = undef,
  Optional[String] $firstaction                      = undef,
  Optional[String] $lastaction                       = undef,
  Integer $rotate                                    = 4,
  Logrotate::Every $rotate_every                     = 'weekly',
  Optional[Logrotate::Size] $size                    = undef,
  Optional[Boolean] $sharedscripts                   = undef,
  Optional[Boolean] $shred                           = undef,
  Optional[Integer] $shredcycles                     = undef,
  Optional[Integer] $start                           = undef,
  Boolean $su                                        = false,
  String $su_user                                    = 'root',
  String $su_group                                   = 'root',
  Optional[String] $uncompresscmd                    = undef
) {
  case $mail {
    /\w+/: { $_mail = "mail ${mail}" }
    false: { $_mail = 'nomail' }
    default: {}
  }

  case $olddir {
    /\w+/: { $_olddir = "olddir ${olddir}" }
    false: { $_olddir = 'noolddir' }
    default: {}
  }

  if $rotate_every {
    $_rotate_every = $rotate_every ? {
      /ly( [0-7])?$/   => $rotate_every,
      'day'            => 'daily',
      default          => "${rotate_every}ly"
    }
  }

  if $create_group and !$create_owner {
    fail("Logrotate::Conf[${name}]: create_group requires create_owner")
  }

  if $create_owner and !$create_mode {
    fail("Logrotate::Conf[${name}]: create_owner requires create_mode")
  }

  if $create_mode and !$create {
    fail("Logrotate::Conf[${name}]: create_mode requires create")
  }

  if $createolddir_group and !$createolddir_owner {
    fail("Logrotate::Conf[${name}]: createolddir_group requires createolddir_owner")
  }

  if $createolddir_owner and !$createolddir_mode {
    fail("Logrotate::Conf[${name}]: createolddir_owner requires createolddir_mode")
  }

  if $createolddir_mode and !$createolddir {
    fail("Logrotate::Conf[${name}]: createolddir_mode requires createolddir")
  }

  #
  ####################################################################

  include logrotate

  $rules_configdir = $logrotate::rules_configdir

  file { $path:
    ensure  => $ensure,
    owner   => $logrotate::root_user,
    group   => $logrotate::root_group,
    mode    => $logrotate::logrotate_conf_mode,
    content => template('logrotate/etc/logrotate.conf.erb'),
  }

  if $logrotate::manage_package {
    Package[$logrotate::package] -> File[$path]
  }
}
