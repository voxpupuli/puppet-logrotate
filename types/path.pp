# @summary File path valid in logrotate config files
type Logrotate::Path = Variant[Stdlib::UnixPath,Array[Stdlib::UnixPath]]
