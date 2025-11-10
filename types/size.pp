# @summary Filesize valid in logrotate config files
type Logrotate::Size = Variant[Integer, Pattern[/^\d+[kMG]?$/]]
