# puppet-hyperglass

[![Build Status](https://travis-ci.com/voxpupuli/puppet-hyperglass.svg?branch=master)](https://travis-ci.com/voxpupuli/puppet-hyperglass)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/hyperglass.svg)](https://forge.puppetlabs.com/puppet/hyperglass)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/hyperglass.svg)](https://forge.puppetlabs.com/puppet/hyperglass)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/hyperglass.svg)](https://forge.puppetlabs.com/puppet/hyperglass)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/hyperglass.svg)](https://forge.puppetlabs.com/puppet/hyperglass)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-hyperglass)
[![AGPL v3 License](https://img.shields.io/github/license/voxpupuli/puppet-hyperglass.svg)](LICENSE)

## Table of contents

* [Hyperglass Setup](#hyperglass-setup)
  * [Examples](#examples)
* [Tests](#tests)
* [Contributions](#contributions)
* [License and Author](#license-and-author)

## Hyperglass Setup

[Hyperglass](https://hyperglass.io/) is shipped as a
[python package](https://pypi.org/project/hyperglass/). This Puppet module
can install all the required services:

* nginx
* redis
* npm
* yarn

And hyperglass itself. It ships gunicorn as a webserver. nginx is used as a
reverse proxy.

### Examples

In case you want this module to manage all the required services, simply do:

```puppet
include hyperglass::server
````

In your puppet code. If this is a box with multiple applications, you might
want to manage the required services on your own. In this case you can do:

```puppet
class { 'hyperglass::server':
  manage_depended_services => false,
}
```

hyperglass needs a list of devices to talk to. You can pass the hash from
the docs to the `$devices` parameter. It will be converted to yaml and written
to the config file.

The same applies for the generic hyperglass server configuration (`$data`
attribute) and specific commands for the devices `$commands` attribute).

```puppet
class { 'hyperglass::server':
  data     => {...},
  commands => {...},
  devices  => {...},
}
```

Please take a look at the official
[hyperglass documentation](https://hyperglass.io/docs/parameters).

It explains the three different options very well. You can pass the hashes
from the documentation 1:1 to the tree parameters.

## Tests

This module has several unit tests and linters configured. You can execute them
by running:

```sh
bundle exec rake test
```

Detailed instructions are in the [CONTRIBUTING.md](.github/CONTRIBUTING.md)
file.

## Contributions

Contribution is fairly easy:

* Fork the module into your namespace
* Create a new branch
* Commit your bugfix or enhancement
* Write a test for it (maybe start with the test first)
* Create a pull request

Detailed instructions are in the [CONTRIBUTING.md](.github/CONTRIBUTING.md)
file.

## License and author

This module was originally written by [Tim Meusel](https://github.com/bastelfreak).
It's licensed with [AGPL version 3](LICENSE).
