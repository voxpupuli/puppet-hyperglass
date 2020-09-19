# @summary writes the hyperglass config files
#
# @param devices hash containing all the devices hyperglass can connect to. Defaults to demo data so the service starts properly.
# @param commands specific commands that can be used by the devices
# @param data generic hyperglass configuration hash
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::server::config (
  Hash $devices  = $hyperglass::server::devices,
  Hash $data     = $hyperglass::server::data,
  Hash $commands = $hyperglass::server::commands,
) {
  assert_private()
  file { '/opt/hyperglass/hyperglass-server/hyperglass/hyperglass.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    content => to_yaml($data),
  }
  file { '/opt/hyperglass/hyperglass-server/hyperglass/commands.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    content => to_yaml($commands),
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/devices.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    content => to_yaml($devices),
  }
}
