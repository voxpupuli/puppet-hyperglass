#!/bin/bash

# using this instead of "rpm -Uvh" to resolve dependencies
function rpm_install() {
    package=$(echo $1 | awk -F "/" '{print $NF}')
    wget --quiet $1
    yum install -y ./$package
    rm -f $package
}

release=$(awk -F \: '{print $5}' /etc/system-release-cpe)

rpm --import http://download-ib01.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-${release}
rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppet
rpm --import http://vault.centos.org/RPM-GPG-KEY-CentOS-${release}

yum install -y wget

# install and configure puppet
rpm -qa | grep -q puppet
if [ $? -ne 0 ]
then

    rpm_install http://yum.puppetlabs.com/puppet5-release-el-${release}.noarch.rpm
    yum -y install puppet-agent
    ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet
fi

# use local hyperglass module
puppet resource file /etc/puppetlabs/code/environments/production/modules/hyperglass ensure=link target=/vagrant

# install module dependencies
puppet module install puppetlabs/stdlib --version ">= 6.4.0 < 7.0.0"
puppet module install camptocamp/systemd --version ">= 2.10.0 < 3.0.0"
puppet module install puppet/redis --version ">= 6.1.0 < 7.0.0"
puppet module install puppet/nginx --version ">= 2.0.0 < 3.0.0"
puppet module install puppet/nodejs --version ">= 8.0.0 < 9.0.0"
puppet module install puppet/python --version ">= 4.1.1 < 5.0.0"

# Install selinux so redis works in vagrant. This is used in hyperglass-server.pp.
puppet module install puppet/selinux --version ">= 3.0.0 < 4.0.0"

puppet resource host hyperglass-server.example.com ensure=present ip=192.168.73.10 host_aliases=hyperglass-server
