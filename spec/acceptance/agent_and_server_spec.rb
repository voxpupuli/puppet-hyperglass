# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'hyperglass::server class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = <<-PUPPET
      include hyperglass::agent
      include hyperglass::server
      # workaround for https://github.com/checktheroads/hyperglass/issues/85
      file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent/agent_cert.pem':
        ensure => 'file',
        owner => 'hyperglass-agent',
        group => 'hyperglass-agent',
        before => Service['hyperglass-agent.service'],
      }
      file { '/opt/hyperglass/hyperglass-agent/hyperglass-agent/agent_key.pem':
        ensure => 'file',
        owner => 'hyperglass-agent',
        group => 'hyperglass-agent',
        before => Service['hyperglass-agent.service'],
      }
      package { 'bird2':
        ensure => 'installed',
        before => Service['hyperglass-agent.service'],
        require => Yumrepo['epel'],
      }
      PUPPET

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      if fact('selinux') == true
        # redis dependency needs two runs to start properly on selinux nodes
        # https://tickets.puppetlabs.com/browse/PUP-10548
        apply_manifest(pp, catch_failures: true)
      end
      apply_manifest(pp, catch_changes: true)
    end
  end
end
