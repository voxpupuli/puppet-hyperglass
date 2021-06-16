require 'spec_helper_acceptance'

describe 'hyperglass::server class' do
  context 'default parameters' do
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

    describe service('nginx') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    # This sleeps because hyperglass can take a long time to start. The service
    # check above returns successfully as the service is running though it has
    # not even bound to a port.
    describe command('sleep 75; curl http://localhost:8001') do
      its(:stdout) { is_expected.to match %r{hyperglass} }
    end
  end
end
