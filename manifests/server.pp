#
# @summary installs the hyperglass looking glass
#
# @see https://hyperglass.io/
#
# @author Tim Meusel <tim@bastelfrek.de>
#
class hyperglass::server {
  unless $facts['os']['name'] in ['CentOS', 'RedHat'] {
    fail('the hyperglass::server class currently only works on CentOS/RedHat')
  }

  contain hyperglass::server::dependencies
  contain hyperglass::server::install
  contain hyperglass::server::config
  contain hyperglass::server::service
}
