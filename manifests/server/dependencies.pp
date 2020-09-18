#
# @summary private class that installs all the services hyperglass depends on
#
# @author Tim Meusel <tim@bastelfrek.de>
#
class hyperglass::server::dependencies {
  assert_private()

  package { ['python3-pip', 'python3-devel', 'gcc']:
    ensure => 'installed',
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
