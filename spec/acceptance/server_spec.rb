require 'spec_helper_acceptance'

describe 'hyperglass::server class' do
  context 'default parameters' do
    # This will allow hiera to lookup test data as hyperglass::server::devices
    # must be populated for the service to start.
    on(hosts, 'mkdir -p /etc/facter/facts.d && echo -e "---\nbeaker: true" > /etc/facter/facts.d/beaker.yaml')

    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = 'include hyperglass::server'

      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      if fact('selinux') == true
        # redis dependency needs two runs to start properly on selinux nodes
        # https://tickets.puppetlabs.com/browse/PUP-10548
        apply_manifest(pp, catch_failures: true)
      end
      apply_manifest(pp, catch_changes: true)
    end

    describe service('hyperglass') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    describe file('/opt/hyperglass/hyperglass-server/hyperglass/devices.yaml') do
      its(:content) { is_expected.to match %r{atl_router01} }
    end

    # This sleeps because hyperglass can take a long time to start. The service
    # check above returns successfully as the service is running though it has
    # not even bound to a port.
    describe command('sleep 60; curl http://0.0.0.0:8001') do
      its(:stdout) { is_expected.to match %r{hyperglass} }
    end
  end
end
