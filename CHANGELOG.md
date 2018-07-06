# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.3.1](https://github.com/voxpupuli/puppet-logrotate/tree/v3.3.1) (2018-07-06)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.3.0...v3.3.1)

**Closed issues:**

- Rerelease 3.3.0 as 3.3.1 [\#121](https://github.com/voxpupuli/puppet-logrotate/issues/121)

## [v3.3.0](https://github.com/voxpupuli/puppet-logrotate/tree/v3.3.0) (2018-06-25)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.2.1...v3.3.0)

**Implemented enhancements:**

- Allow change of file mode for generated files [\#70](https://github.com/voxpupuli/puppet-logrotate/issues/70)
- Fix freebsd default rules [\#111](https://github.com/voxpupuli/puppet-logrotate/pull/111) ([kapouik](https://github.com/kapouik))
- Fix Issue 70 add file mode parameters [\#109](https://github.com/voxpupuli/puppet-logrotate/pull/109) ([TJM](https://github.com/TJM))
- Use logrotate::cron rather than file resource for hourly cron [\#105](https://github.com/voxpupuli/puppet-logrotate/pull/105) ([pjfbashton](https://github.com/pjfbashton))
- Manage logrotate startup arguments [\#102](https://github.com/voxpupuli/puppet-logrotate/pull/102) ([ruriky](https://github.com/ruriky))

**Closed issues:**

- duplicate resource or dependency cycle when attempting to set default options [\#116](https://github.com/voxpupuli/puppet-logrotate/issues/116)

**Merged pull requests:**

- \(docs\) Update readme with warning note and bigger example of defaults [\#117](https://github.com/voxpupuli/puppet-logrotate/pull/117) ([GeoffWilliams](https://github.com/GeoffWilliams))
- Remove docker nodesets [\#115](https://github.com/voxpupuli/puppet-logrotate/pull/115) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#113](https://github.com/voxpupuli/puppet-logrotate/pull/113) ([bastelfreak](https://github.com/bastelfreak))

## [v3.2.1](https://github.com/voxpupuli/puppet-logrotate/tree/v3.2.1) (2018-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.2.0...v3.2.1)

**Merged pull requests:**

- bump puppet to latest supported version 4.10.0 [\#107](https://github.com/voxpupuli/puppet-logrotate/pull/107) ([bastelfreak](https://github.com/bastelfreak))

## [v3.2.0](https://github.com/voxpupuli/puppet-logrotate/tree/v3.2.0) (2018-01-04)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Deprecation warnings from newer stdlib [\#54](https://github.com/voxpupuli/puppet-logrotate/issues/54)
- Add option to not manage logrotate package [\#44](https://github.com/voxpupuli/puppet-logrotate/issues/44)
- Add manage\_package parameter [\#97](https://github.com/voxpupuli/puppet-logrotate/pull/97) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Make the creation of default \[bw\]tmp-rulesets configurable [\#65](https://github.com/voxpupuli/puppet-logrotate/pull/65) ([mcgege](https://github.com/mcgege))
- Add purge\_configdir to purge old configs [\#23](https://github.com/voxpupuli/puppet-logrotate/pull/23) ([patricktoelle](https://github.com/patricktoelle))

**Fixed bugs:**

- 'su root syslog' line missing in default logrotate.conf file for Ubuntu produced by this module [\#93](https://github.com/voxpupuli/puppet-logrotate/issues/93)
- Pattern matcher in Logrotate::UserOrGroup is too strict. Doesn't allow names with domain. [\#88](https://github.com/voxpupuli/puppet-logrotate/issues/88)
- Enum on package ensure is too restrictive [\#84](https://github.com/voxpupuli/puppet-logrotate/issues/84)
- logrotate::conf\[/etc/logrotate.conf\] [\#49](https://github.com/voxpupuli/puppet-logrotate/issues/49)
- copy and copytruncate marked in rules.pp as optional [\#31](https://github.com/voxpupuli/puppet-logrotate/issues/31)
- copytruncate =\> true affects logrotate::defaults wtmp and btmp rules [\#22](https://github.com/voxpupuli/puppet-logrotate/issues/22)
- Remove UserOrGroup type, use String [\#98](https://github.com/voxpupuli/puppet-logrotate/pull/98) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Allow logrotate version to be specified [\#96](https://github.com/voxpupuli/puppet-logrotate/pull/96) ([juniorsysadmin](https://github.com/juniorsysadmin))
- Fix missing su line in default logrotate.conf on Ubuntu [\#92](https://github.com/voxpupuli/puppet-logrotate/pull/92) ([szponek](https://github.com/szponek))
- Add missing $maxsize option to Logrotate::Conf [\#90](https://github.com/voxpupuli/puppet-logrotate/pull/90) ([achermes](https://github.com/achermes))

**Closed issues:**

- parameter 'path' references an unresolved type 'Stdlib::UnixPath' [\#95](https://github.com/voxpupuli/puppet-logrotate/issues/95)
- logrotate::rule adds blank su to wtmp and btmp [\#41](https://github.com/voxpupuli/puppet-logrotate/issues/41)
- Add tests for all OSes for defaults.pp [\#3](https://github.com/voxpupuli/puppet-logrotate/issues/3)

**Merged pull requests:**

- Remove obsolete su parameter in documentation [\#91](https://github.com/voxpupuli/puppet-logrotate/pull/91) ([stefanandres](https://github.com/stefanandres))

## [v3.1.0](https://github.com/voxpupuli/puppet-logrotate/tree/v3.1.0) (2017-11-13)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.0.1...v3.1.0)

**Implemented enhancements:**

- Allow dateyesterday at the global level [\#83](https://github.com/voxpupuli/puppet-logrotate/pull/83) ([cliff-wakefield](https://github.com/cliff-wakefield))

**Fixed bugs:**

- Fix "Puppet Unknown variable: 'default\_su\_group'" [\#82](https://github.com/voxpupuli/puppet-logrotate/pull/82) ([mookie-](https://github.com/mookie-))

**Closed issues:**

- Config is not a string but a hash [\#77](https://github.com/voxpupuli/puppet-logrotate/issues/77)
- Support Ubuntu 16.04 [\#59](https://github.com/voxpupuli/puppet-logrotate/issues/59)
- Does this module attempt to apply the defaults for the GNU distribution? [\#48](https://github.com/voxpupuli/puppet-logrotate/issues/48)

## [v3.0.1](https://github.com/voxpupuli/puppet-logrotate/tree/v3.0.1) (2017-10-14)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.0.0...v3.0.1)

**Fixed bugs:**

- wrong datatype for $config, s/String/Hash [\#78](https://github.com/voxpupuli/puppet-logrotate/pull/78) ([bastelfreak](https://github.com/bastelfreak))

## [v3.0.0](https://github.com/voxpupuli/puppet-logrotate/tree/v3.0.0) (2017-10-10)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v2.0.0...v3.0.0)

**Closed issues:**

- Remove old CHANGELOG or merge with CHANGELOG.md [\#69](https://github.com/voxpupuli/puppet-logrotate/issues/69)

**Merged pull requests:**

- Fix changelog [\#73](https://github.com/voxpupuli/puppet-logrotate/pull/73) ([alexjfisher](https://github.com/alexjfisher))
- Added support for dateyesterday within logrotate::rule [\#71](https://github.com/voxpupuli/puppet-logrotate/pull/71) ([cliff-wakefield](https://github.com/cliff-wakefield))
- BREAKING: Introduce Puppet 4 datatypes and drop Puppet 3 support [\#68](https://github.com/voxpupuli/puppet-logrotate/pull/68) ([mmerfort](https://github.com/mmerfort))

## [v2.0.0](https://github.com/voxpupuli/puppet-logrotate/tree/v2.0.0) (2017-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v1.4.0...v2.0.0)

**Closed issues:**

- Logrotate rule ERB template should not take variables from the scope object [\#37](https://github.com/voxpupuli/puppet-logrotate/issues/37)
- Ubuntu Xenial 16.04 compaibility [\#34](https://github.com/voxpupuli/puppet-logrotate/issues/34)
- string 'undef' now treated as undef [\#26](https://github.com/voxpupuli/puppet-logrotate/issues/26)
- Allow adjustment of OS-specific defaults [\#9](https://github.com/voxpupuli/puppet-logrotate/issues/9)

**Merged pull requests:**

- Fix typo [\#58](https://github.com/voxpupuli/puppet-logrotate/pull/58) ([gabe-sky](https://github.com/gabe-sky))
- Adding support for maxsize also in main config [\#57](https://github.com/voxpupuli/puppet-logrotate/pull/57) ([seefood](https://github.com/seefood))
- Fix rubocop checks [\#53](https://github.com/voxpupuli/puppet-logrotate/pull/53) ([coreone](https://github.com/coreone))
- Fixes \#34 - Ubuntu Xenial and up support [\#43](https://github.com/voxpupuli/puppet-logrotate/pull/43) ([edestecd](https://github.com/edestecd))
- Fixes \#37 - Logrotate rule ERB template should not take variables from the scope object [\#38](https://github.com/voxpupuli/puppet-logrotate/pull/38) ([imriz](https://github.com/imriz))
- Fix puppet-lint issues and bad style [\#32](https://github.com/voxpupuli/puppet-logrotate/pull/32) ([baurmatt](https://github.com/baurmatt))
- Add gentoo support [\#27](https://github.com/voxpupuli/puppet-logrotate/pull/27) ([baurmatt](https://github.com/baurmatt))

## [v1.4.0](https://github.com/voxpupuli/puppet-logrotate/tree/v1.4.0) (2016-05-30)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v1.3.0...v1.4.0)

**Closed issues:**

- Optional config settings are no longer optional?!? [\#29](https://github.com/voxpupuli/puppet-logrotate/issues/29)
- wtmp and btmp are different when using the future parser [\#13](https://github.com/voxpupuli/puppet-logrotate/issues/13)

**Merged pull requests:**

- Changed default string "undef" to "UNDEFINED" to work around this bug… [\#28](https://github.com/voxpupuli/puppet-logrotate/pull/28) ([durist](https://github.com/durist))
- Fix typo in README.md [\#25](https://github.com/voxpupuli/puppet-logrotate/pull/25) ([siebrand](https://github.com/siebrand))
- Added ability to override default btmp and/or wtmp [\#21](https://github.com/voxpupuli/puppet-logrotate/pull/21) ([ncsutmf](https://github.com/ncsutmf))
- remove special whitespace character [\#20](https://github.com/voxpupuli/puppet-logrotate/pull/20) ([jfroche](https://github.com/jfroche))
- Update Gemfile for Rake/Ruby version dependencies [\#19](https://github.com/voxpupuli/puppet-logrotate/pull/19) ([ncsutmf](https://github.com/ncsutmf))
- add official puppet 4 support [\#17](https://github.com/voxpupuli/puppet-logrotate/pull/17) ([mmckinst](https://github.com/mmckinst))

## [v1.3.0](https://github.com/voxpupuli/puppet-logrotate/tree/v1.3.0) (2015-11-05)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v1.2.8...v1.3.0)

**Closed issues:**

- The logrotate package should be 'present' by default, or at least tunable [\#11](https://github.com/voxpupuli/puppet-logrotate/issues/11)

**Merged pull requests:**

- Set default package ensure value to 'installed' [\#12](https://github.com/voxpupuli/puppet-logrotate/pull/12) ([natemccurdy](https://github.com/natemccurdy))
- Add support for maxsize directive [\#10](https://github.com/voxpupuli/puppet-logrotate/pull/10) ([zeromind](https://github.com/zeromind))

## v1.2.8 (2015-09-14)

- Fix hidden unicode character (#8)
- Allow config to be passed in as an hash (#6)
- Fix dependency issue (#7)
- refactor main class (mostly to facilitate #7)
- update test environment to use puppet 4
- switch stdlib fixture to https source

## v1.2.7 (2015-05-06)

- Metadata-only release (just bumped version)

## v1.2.6 (2015-05-06)

- Fix test failures on future parser

## v1.2.5 (2015-05-06)

- Switch some validation code to use validate_re

## v1.2.4 (2015-05-06)

- Add puppet-lint exclusions

## v1.2.3 (2015-05-06)

- More work on testing
- fix warning when running puppet module list caused by "-" instead of "/" in dependencies in metadata

## v1.2.3 (2015-05-06)

- removed (pushed without CHANGELOG update

## v1.2.1 (2015-05-06)

- Update tests, Rakefile, etc.

## v1.2.0 (2015-03-25)

- First release to puppetforge


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
