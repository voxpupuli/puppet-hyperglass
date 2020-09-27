# @summary installs the hyperglass linux agent
#
# @param manage_python
#   installs python3
# @param manage_gcc
#   installs gcc
# @param manage_user
#   When true, the user 'hyperglass-agent' is managed.
# @param manage_group
#   When true, the group 'hyperglass-agent' is managed.
# @param data
#   generic hyperglass configuration hash.
#
# @see https://github.com/checktheroads/hyperglass-agent
#
class hyperglass::agent (
  Boolean $manage_python = true,
  Boolean $manage_gcc = true,
  Boolean $manage_user = true,
  Boolean $manage_group = true,
  Hash $data = {
    'debug'          => true,
    'listen_address' => '127.0.0.1',
    'mode'           => 'bird',
    'secret'         => fqdn_rand_string(20),
    'ssl'            => {
      'enable' => false,
    },
  },
) {
  include hyperglass

  if $manage_python {
    ensure_resource('class', 'python', { 'version' => '3', 'dev' => 'present' })
  }

  if $manage_gcc {
    ensure_resource('package', 'gcc', { 'ensure' => 'installed' })
  }

  if $manage_user {
    user { 'hyperglass-agent':
      ensure         => 'present',
      managehome     => true,
      purge_ssh_keys => true,
      system         => true,
      home           => '/opt/hyperglass/hyperglass-agent',
    }
  }

  if $manage_group {
    group { 'hyperglass-agent':
      ensure => 'present',
      system => true,
    }
  }

  file { '/opt/hyperglass/hyperglass-agent':
    ensure => 'directory',
    owner  => 'hyperglass-agent',
    group  => 'hyperglass-agent',
    mode   => '0700',
    notify => Systemd::Unit_file['hyperglass-agent.service'],
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
    notify     => Systemd::Unit_file['hyperglass-agent.service'],
  }

  python::pip { 'hyperglass-agent':
    virtualenv => '/opt/hyperglass/hyperglass-agent/virtualenv',
    owner      => 'hyperglass-agent',
    group      => 'hyperglass-agent',
    notify     => Systemd::Unit_file['hyperglass-agent.service'],
  }

  file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent':
    ensure => 'directory',
    owner  => 'hyperglass-agent',
    group  => 'hyperglass-agent',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass-agent.service'],
  }

  file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent/config.yaml':
    ensure  => 'file',
    owner   => 'hyperglass-agent',
    group   => 'hyperglass-agent',
    mode    => '0400',
    content => to_yaml($data),
    notify  => Systemd::Unit_file['hyperglass-agent.service'],
  }

  systemd::unit_file { 'hyperglass-agent.service':
    source => 'puppet:///modules/hyperglass/hyperglass-agent.service',
    enable => true,
    active => true,
  }
}
