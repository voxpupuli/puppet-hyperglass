# @summary private class used by server/agent to install python3
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::python {
  assert_private()

  class { 'python':
    version => '3',
    dev     => 'present',
  }
}
