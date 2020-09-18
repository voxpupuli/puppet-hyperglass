#
# @summary installs the hyperglass looking glass
#
# @param manage_depended_services if true, installs all other services that hyperglass requires, like redis, yarn, nginx, python
#
# @see https://hyperglass.io/
#
# @author Tim Meusel <tim@bastelfrek.de>
#
class hyperglass::server (
  Boolean $manage_depended_services = true,
  Hash $devices = { 'routers' => [{ 'name' => 'atl_router01', 'address' => '10.0.0.2', 'network' => { 'name' => 'secondary', 'display_name' => 'That Other Network', }, 'credential' => { 'username' => 'user2', 'password' => ' secret2' }, 'display_name' => 'Atlanta, GA', 'port' => 22, 'nos' => 'juniper', 'vrfs' => [{ 'name' => 'default', 'display_name' => 'Global', 'ipv4' => { 'source_address' => '192.0.2.2' } }] }] },
) {
  unless $facts['os']['name'] in ['CentOS', 'RedHat'] {
    fail('the hyperglass::server class currently only works on CentOS/RedHat')
  }

  if $manage_depended_services {
    contain hyperglass::server::dependencies
    Class['hyperglass::server::dependencies']
    -> Class['hyperglass::server::install']
  }

  contain hyperglass::server::install
  contain hyperglass::server::config
  contain hyperglass::server::service

  Class['hyperglass::server::install']
  -> Class['hyperglass::server::config']
  ~> Class['hyperglass::server::service']
}
