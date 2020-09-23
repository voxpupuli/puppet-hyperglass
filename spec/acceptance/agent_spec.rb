require 'spec_helper_acceptance'

describe 'hyperglass::agent class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = <<-PUPPET
      include hyperglass::agent
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
      apply_manifest(pp, catch_changes: true)
    end

    describe service('hyperglass-agent') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe port(8080) do
      it { is_expected.to be_listening.with('tcp') }
    end
  end
end
