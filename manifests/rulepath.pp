define logrotate::rulepath (
  $rule = undef,
  $order = "01",
  $hourly = false,
  $path = undef,
) {

  if (is_array($path)) {
    $rpath = join($path, " ")
  } else {
    $rpath = $path
  }
  if ($hourly) {
    $rule_path = "/etc/logrotate.d/hourly/${rule}"
  } else {
    $rule_path = "/etc/logrotate.d/${rule}"
  }
  concat::fragment { $name:
    target => $rule_path,
    order => $order,
    content => "$rpath ",
  }
}
