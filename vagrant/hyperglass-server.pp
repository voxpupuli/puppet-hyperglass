# If you enable selinux, redis will not be able to write to its data directory
# and will not properly start without the following.
selinux::permissive { 'redis_t':
  ensure => 'present',
  before => Class['redis::service'],
}

class { 'hyperglass::server':
  # Without this, hyperglass binds to localhost and port forwarding with
  # vagrant will not work.
  data => {
    'listen_address' => '0.0.0.0',
  },
}
