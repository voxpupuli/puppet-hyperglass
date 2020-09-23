# @summary manages the hyperglass service + unit file
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::server::service {
  assert_private()
  systemd::unit_file { 'hyperglass.service':
    source  => "puppet:///modules/${module_name}/hyperglass.service",
    enable  => true,
    active  => true,
    require => File['/opt/hyperglass/hyperglass-server/hyperglass/static/images'],
  }
}
