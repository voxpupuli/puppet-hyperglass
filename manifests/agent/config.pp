# @summary configures the hyperglass looking agent
#
# @api private
#
class hyperglass::agent::config (
  Hash $data = $hyperglass::agent::data,
) {
  assert_private()

  file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent/config.yaml':
    ensure  => 'file',
    owner   => 'hyperglass-agent',
    group   => 'hyperglass-agent',
    mode    => '0400',
    content => to_yaml($data),
  }
}
