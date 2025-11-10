# @summary Apply user-defined rules
# @api private
#
class logrotate::rules ($rules = $logrotate::rules) {
  assert_private()

  create_resources('logrotate::rule', $rules)
}
