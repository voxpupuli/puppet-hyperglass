# @summary manages the hyperglass agent service + unit file
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::agent::service {
  assert_private()
  systemd::unit_file { 'hyperglass-agent.service':
    source => "puppet:///modules/${module_name}/hyperglass-agent.service",
    enable => true,
    active => true,
  }
}
