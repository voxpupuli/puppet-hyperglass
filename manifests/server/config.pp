class hyperglass::server::config (
  Hash $devices = $hyperglass::server::devices,
) {
  assert_private()
  file { ['/opt/hyperglass/hyperglass/hyperglass.yaml', '/opt/hyperglass/hyperglass/commands.yaml']:
    ensure => 'file',
    owner  => 'hyperglass',
    group  => 'hyperglass',
  }
  file { '/opt/hyperglass/hyperglass/devices.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    content => to_yaml($devices),
  }
}
