# @summary Manage the Hyperglass bits that are common to both agent and server.
#
# @api private
#
class hyperglass {
  file { '/opt/hyperglass':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
