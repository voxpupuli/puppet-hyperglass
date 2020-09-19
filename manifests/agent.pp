# @summary installs the hyperglass linux agent
#
# @param manage_python installs python3
# @param manage_gcc installs gcc
# @param data generic hyperglass configuration hash.
#
# @see https://github.com/checktheroads/hyperglass-agent
#
# @author Tim Meusel <tim@bastelfreak.de>
class hyperglass::agent (
  Boolean $manage_python = true,
  Boolean $manage_gcc    = true,
  Hash $data             = {
    'debug'          => true,
    'listen_address' => '127.0.0.1',
    'mode'           => 'bird',
    'secret'         => fqdn_rand_string(20),
    'ssl'            => {
      'enable' => false,
    },
  },
) {
  require hyperglass::hyperglassdir
  contain hyperglass::agent::install
  contain hyperglass::agent::config
  contain hyperglass::agent::service
  Class['hyperglass::agent::install']
  -> Class['hyperglass::agent::config']
  ~> Class['hyperglass::agent::service']
}
