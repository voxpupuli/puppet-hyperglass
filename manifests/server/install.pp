#
# @summary installs the hyperglass server
#
# @author Tim Meusel <tim@bastelfrek.de>
#
class hyperglass::server::install {
  assert_private()
  user { 'hyperglass':
    ensure         => 'present',
    managehome     => true,
    purge_ssh_keys => true,
    system         => true,
    home           => '/opt/hyperglass',
  }
  group { 'hyperglass':
    ensure => 'present',
    system => true,
  }

  file { '/opt/hyperglass/hyperglass':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
  }

  file { '/opt/hyperglass/hyperglass/static':
    ensure  => 'directory',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    require => File['/opt/hyperglass/hyperglass'],
  }
  file { ['/opt/hyperglass/hyperglass/static/ui', '/opt/hyperglass/hyperglass/static/images', '/opt/hyperglass/hyperglass/static/custom']:
    ensure  => 'directory',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    require => File['/opt/hyperglass/hyperglass/static'],
  }
  file { '/opt/hyperglass/hyperglass/static/images/favicons':
    ensure  => 'directory',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    require => File['/opt/hyperglass/hyperglass/static/images'],
  }

  # we need to explicitly set the version here. During the first puppet run, python3 will be installed but isn't present yet
  # due to that the fact is undef and fails. the default of the `version` attribute is the fact. We workaround this by hardcoding
  # the python version
  python::pyvenv { '/opt/hyperglass/virtualenv':
    ensure     => 'present',
    owner      => 'hyperglass',
    group      => 'hyperglass',
    systempkgs => false,
    version    => pick($facts['python3_version'], '3.6'),
  }

  python::pip { 'hyperglass':
    virtualenv => '/opt/hyperglass/virtualenv',
    owner      => 'hyperglass',
    group      => 'hyperglass',
  }
}
