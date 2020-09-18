class hyperglass::server::config {
  assert_private()
  file { ['/opt/hyperglass/hyperglass/devices.yaml', '/opt/hyperglass/hyperglass/hyperglass.yaml', '/opt/hyperglass/hyperglass/commands.yaml']:
    ensure => 'file',
    owner  => 'hyperglass',
    group  => 'hyperglass',
  }
}
