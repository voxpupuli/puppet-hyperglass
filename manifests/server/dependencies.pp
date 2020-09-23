# @summary private class that installs all the services hyperglass depends on
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::server::dependencies (
  Boolean $manage_python = $hyperglass::server::manage_python,
  Boolean $manage_gcc    = $hyperglass::server::manage_gcc,
) {
  assert_private()

  if $manage_python {
    require hyperglass::python
  }
  if $manage_gcc {
    require hyperglass::gcc
  }
  class { 'redis::globals':
    scl => 'rh-redis5',
  }
  -> class { 'redis':
    manage_repo => true,
  }

  class { 'nodejs':
    repo_url_suffix => '14.x',
  }

  yumrepo { 'yarn':
    ensure   => 'present',
    baseurl  => 'https://dl.yarnpkg.com/rpm/',
    gpgcheck => 1,
    gpgkey   => 'https://dl.yarnpkg.com/rpm/pubkey.gpg',
    descr    => 'Yarn Repository',
  }

  package { 'yarn':
    ensure  => 'present',
    require => Yumrepo['yarn'],
  }

  include nginx
}
