# @summary module to workaround the broken puppetlabs/gcc class. Installs just gcc
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::gcc {
  assert_private()
  package { 'gcc':
    ensure => 'installed',
  }
}
