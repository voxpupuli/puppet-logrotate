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
  Stdlib::Unixpath $path = $name,
  Enum['absent','present'] $ensure = 'present',
  Optional[Boolean] $compress = undef,
  Optional[String]  $compresscmd = undef,
  Optional[String]  $compressext = undef,
  Optional[String]  $compressoptions = undef,
  Optional[Boolean] $copy = undef,
  Optional[Boolean] $copytruncate = undef,
  Boolean           $create = true,
  Optional[String]  $create_mode     = undef,
  Optional[String]  $create_owner    = undef,
  Optional[String]  $create_group    = undef,
  Optional[Boolean] $dateext         = undef,
  Optional[String]  $dateformat      = undef,
  Optional[Boolean] $delaycompress   = undef,
  Optional[String]  $extension       = undef,
  Optional[Boolean] $ifempty         = undef,
  Optional[Variant[String,Boolean]] $mail            = undef,
  Optional[Enum['mailfirst', 'maillast']] $mail_when = undef,
  Optional[Integer] $maxage          = undef,
  Optional[Logrotate::Size] $minsize = undef,
  Optional[Boolean] $missingok = undef,
  Optional[Variant[Boolean,String]] $olddir = undef,
  Optional[String]  $postrotate = undef,
  Optional[String]  $prerotate = undef,
  Optional[String]  $firstaction = undef,
  Optional[String]  $lastaction = undef,
  Integer $rotate = 4,
  Logrotate::Every $rotate_every = 'weekly',
  Optional[Logrotate::Size] $size = undef,
  Optional[Boolean] $sharedscripts = undef,
  Optional[Boolean] $shred = undef,
  Optional[Integer] $shredcycles = undef,
  Optional[Integer] $start = undef,
  Optional[Logrotate::UserOrGroup] $su_user = undef,
  Optional[Logrotate::UserOrGroup] $su_group = undef,
  Optional[String] $uncompresscmd   = undef
) {


  case $mail {
    /\w+/: { $_mail = "mail ${mail}" }
    false: { $_mail = 'nomail' }
    default: { }
  }

  case $olddir {
    /\w+/: { $_olddir = "olddir ${olddir}" }
    false: { $_olddir = 'noolddir' }
    default: { }
  }

  if $rotate_every {
    $_rotate_every = $rotate_every ? {
      /ly$/   => $rotate_every,
      'day'   => 'daily',
      default => "${rotate_every}ly"
    }
  }

  if $su_user and !defined('$su_group') {
    $_su_user  = $su_user
    $_su_group = 'root'
  } elsif !defined('$su_user') and $su_group {
    $_su_user  = 'root'
    $_su_group = $su_group
  } else {
    $_su_user  = $su_user
    $_su_group = $su_group
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

  #
  ####################################################################

  include ::logrotate

  file { $path:
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0444',
    content => template('logrotate/etc/logrotate.conf.erb'),
    require => Package['logrotate'],
  }
}
