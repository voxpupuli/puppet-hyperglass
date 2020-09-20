# If you enable selinux, redis will not be able to write to its data directory
# and will not properly start without the following.
selinux::permissive { 'redis_t':
  ensure => 'present',
  before => Class['redis::service'],
}

class { 'hyperglass::server':
  # Without this, hyperglass binds to localhost and port forwarding with
  # vagrant will not work.
  data    => {
    'listen_address' => '0.0.0.0',
  },
  devices => {
    'routers' => [
      {
        'name'         => 'atl_router01',
        'address'      => '10.0.0.2',
        'network'      => {
          'name'         => 'secondary',
          'display_name' => 'That Other Network',
        },
        'credential'   => {
          'username' => 'user2',
          'password' => ' secret2',
        },
        'display_name' => 'Atlanta, GA',
        'port'         => 22,
        'nos'          => 'juniper',
        'vrfs'         => [
          {
            'name'         => 'default',
            'display_name' => 'Global',
            'ipv4'         => {
              'source_address' => '192.0.2.2',
            },
          },
        ],
      },
    ],
  },
}
