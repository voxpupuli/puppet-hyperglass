class hyperglass::server::service {
  assert_private()
  systemd::unit_file { 'hyperglass.service':
    source  => "puppet:///modules/${module_name}/configs/hyperglass.service",
    enable  => true,
    active  => true,
    require => File['/opt/hyperglass/hyperglass/static/images'],
  }
}
