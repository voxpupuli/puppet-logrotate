# apply defaults
#
class logrotate::defaults ($rule_default, $rules = { }){

  assert_private()

  if !defined( Logrotate::Conf[$::logrotate::params::config_file] ) {
    logrotate::conf{ $::logrotate::params::config_file:
      * => $::logrotate::params::conf_params,
    }
  }

  $rules.each |$rule_name, $params| {
    if !defined(Logrotate::Rule[$rule_name]) {
      $_merged_params =
        merge($rule_default,$params)
      logrotate::rule{ $rule_name:
        * => $_merged_params,
      }
    }
  }

}
