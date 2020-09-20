file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent/agent_cert.pem':
  ensure => 'file',
  owner  => 'hyperglass-agent',
  group  => 'hyperglass-agent',
  before => Service['hyperglass-agent.service'],
}

file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent/agent_key.pem':
  ensure => 'file',
  owner  => 'hyperglass-agent',
  group  => 'hyperglass-agent',
  before => Service['hyperglass-agent.service'],
}

package { 'bird2':
  ensure  => 'installed',
  before  => Service['hyperglass-agent.service'],
  require => Yumrepo['epel'],
}

class { 'hyperglass::agent':
  data => {
    'debug'          => true,
    'listen_address' => '0.0.0.0',
    'mode'           => 'bird',
    'secret'         => fqdn_rand_string(20),
    'ssl'            => {
      'enable' => false,
    },
  },
}
