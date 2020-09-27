# @summary Manage Hyperglass looking glass server software
#
# @param manage_depended_services
#   if true, installs all other services that hyperglass requires, like redis,
#   yarn, nginx, python
# @param manage_gcc
#   installs gcc
# @param manage_node
#   Includes the nodejs class using version 14.x
# @param manage_nginx
#   Includes the nginx class
# @param manage_python
#   installs python3
# @param manage_redis
#   Installs redis5 from SCL.
# @param manage_yarn
#   Manages yarn repo and package.
# @param manage_user
#   When true, the user 'hyperglass' is managed.
# @param manage_group
#   When true, the group 'hyperglass' is managed.
# @param python_version
#   Specifies which version of python will be used by python::pyvenv if the
#   `python3_version` fact is not found.
# @param devices
#   Hash containing all the devices managed by hyperglass.
# @param commands
#   Specific commands that can be used by the devices
# @param data
#   Generic hyperglass configuration hash.
#
# @see https://hyperglass.io/
#
class hyperglass::server (
  Boolean $manage_depended_services = true,
  Boolean $manage_gcc = true,
  Boolean $manage_node = true,
  Boolean $manage_nginx = true,
  Boolean $manage_python = true,
  Boolean $manage_redis = true,
  Boolean $manage_yarn = true,
  Boolean $manage_user = true,
  Boolean $manage_group = true,
  String[1] $python_version = '3.6',
  Hash $data = {},
  Hash $commands = {},
  Hash $devices = {},
) {
  if $facts['os']['family'] != 'RedHat' {
    warning('This module only supports the RedHat family of platforms.')
  }

  include hyperglass

  if $manage_depended_services {
    if $manage_nginx {
      include nginx
    }

    if $manage_python {
      ensure_resource('class', 'python', { 'version' => '3', 'dev' => 'present' })
    }

    if $manage_gcc {
      ensure_resource('package', 'gcc', { 'ensure' => 'installed' })
    }

    if $manage_redis {
      class { 'redis::globals':
        scl    => 'rh-redis5',
        before => Class['redis'],
      }

      class { 'redis':
        manage_repo => true,
      }
    }

    if $manage_node {
      class { 'nodejs':
        repo_url_suffix => '14.x',
      }
    }

    if $manage_yarn {
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
    }
  }

  if $manage_user {
    user { 'hyperglass':
      ensure         => 'present',
      managehome     => true,
      purge_ssh_keys => true,
      system         => true,
      home           => '/opt/hyperglass/hyperglass-server',
    }
  }

  if $manage_group {
    group { 'hyperglass':
      ensure => 'present',
      system => true,
    }
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/static':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/static/custom':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/static/ui':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/static/images':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/static/images/favicons':
    ensure => 'directory',
    owner  => 'hyperglass',
    group  => 'hyperglass',
    mode   => '0755',
    notify => Systemd::Unit_file['hyperglass.service'],
  }

  # we need to explicitly set the version here. During the first puppet run,
  # python3 will be installed but isn't present yet due to that the fact is
  # undef and fails. the default of the `version` attribute is the fact. We
  # workaround this by hardcoding the python version
  python::pyvenv { '/opt/hyperglass/hyperglass-server/virtualenv':
    ensure     => 'present',
    owner      => 'hyperglass',
    group      => 'hyperglass',
    systempkgs => false,
    version    => pick($facts['python3_version'], $python_version),
    notify     => Systemd::Unit_file['hyperglass.service'],
  }

  python::pip { 'hyperglass':
    virtualenv => '/opt/hyperglass/hyperglass-server/virtualenv',
    owner      => 'hyperglass',
    group      => 'hyperglass',
    notify     => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/hyperglass.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    mode    => '0644',
    content => to_yaml($data),
    notify  => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/commands.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    mode    => '0644',
    content => to_yaml($commands),
    notify  => Systemd::Unit_file['hyperglass.service'],
  }

  file { '/opt/hyperglass/hyperglass-server/hyperglass/devices.yaml':
    ensure  => 'file',
    owner   => 'hyperglass',
    group   => 'hyperglass',
    mode    => '0644',
    content => to_yaml($devices),
    notify  => Systemd::Unit_file['hyperglass.service'],
  }

  systemd::unit_file { 'hyperglass.service':
    source => 'puppet:///modules/hyperglass/hyperglass.service',
    enable => true,
    active => true,
  }
}
