class hyperglass::server::install {
  assert_private()
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

  python::pyvenv { '/opt/hyperglass/virtualenv':
    ensure     => 'present',
    owner      => 'hyperglass',
    group      => 'hyperglass',
    systempkgs => false,
  }

  python::pip { 'hyperglass':
    virtualenv => '/opt/hyperglass/virtualenv',
    owner      => 'hyperglass',
    group      => 'hyperglass',
  }
}
