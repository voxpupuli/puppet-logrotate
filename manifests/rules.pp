# apply user-defined rules
class logrotate::rules {

  assert_private()

  if $::logrotate::hieramerge {
      $rules = lookup("logrotate::rules", Hash, 'deep', {})
  } else {
      $rules = $::logrotate::rules
  }

  create_resources('logrotate::rule', $rules)

}
