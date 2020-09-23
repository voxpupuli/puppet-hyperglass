# @summary installs the hyperglass agent on linux nodes
#
# @api private
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::agent::install (
  Boolean $manage_python = $hyperglass::agent::manage_python,
  Boolean $manage_gcc    = $hyperglass::agent::manage_gcc,
) {
  assert_private()

  if $manage_python {
    require hyperglass::python
  }
  if $manage_gcc {
    require hyperglass::gcc
  }
  user { 'hyperglass-agent':
    ensure         => 'present',
    managehome     => true,
    purge_ssh_keys => true,
    system         => true,
    home           => '/opt/hyperglass/hyperglass-agent',
  }
  group { 'hyperglass-agent':
    ensure => 'present',
    system => true,
  }

  file { '/opt/hyperglass/hyperglass-agent':
    ensure => 'directory',
    owner  => 'hyperglass-agent',
    group  => 'hyperglass-agent',
  }

  # we need to explicitly set the version here. During the first puppet run, python3 will be installed but isn't present yet
  # due to that the fact is undef and fails. the default of the `version` attribute is the fact. We workaround this by hardcoding
  # the python version
  python::pyvenv { '/opt/hyperglass/hyperglass-agent/virtualenv':
    ensure     => 'present',
    owner      => 'hyperglass-agent',
    group      => 'hyperglass-agent',
    systempkgs => false,
    version    => pick($facts['python3_version'], '3.6'),
  }

  python::pip { 'hyperglass-agent':
    virtualenv => '/opt/hyperglass/hyperglass-agent/virtualenv',
    owner      => 'hyperglass-agent',
    group      => 'hyperglass-agent',
  }

  file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent':
    ensure => 'directory',
    owner  => 'hyperglass-agent',
    group  => 'hyperglass-agent',
  }
}
