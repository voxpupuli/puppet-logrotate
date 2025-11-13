# @summary Valid configuration values for rotation (every hour/day/week/month etc.) 
type Logrotate::Every = Pattern['^hour(|ly)$','^da(|il)y$','^week(|ly)( [0-7])?$','^month(|ly)$','^year(|ly)$']
