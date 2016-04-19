# SELinux rules for logrotate
class logrotate::selinux {
  if $::osfamily == 'RedHat' {
    selinux::module { 'site-logrotate':
      ensure => 'present',
      source => 'puppet:///modules/logrotate/site-logrotate.te',
    }
  }
}
