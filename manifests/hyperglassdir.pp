# @summary private class to create the main dir for hyperglass server and agent
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::hyperglassdir {
  assert_private()

  file { '/opt/hyperglass/':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
  }
}
