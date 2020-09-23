require 'spec_helper_acceptance'

describe 'hyperglass::server class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'works with no errors' do
      pp = 'include hyperglass::server'

      # Run it three times and test for idempotency
      # redis dependency needs two run twice to start properly on selinux nodes
      # selinux is only enabled in vagrant images, not docker
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe service('hyperglass') do
      it { is_expected.to be_running }
      it { is_expected.to be_enabled }
    end

    # This sleeps because hyperglass can take a long time to start. The service
    # check above returns successfully as the service is running though it has
    # not even bound to a port.
    describe command('sleep 60; curl http://localhost:8001') do
      its(:stdout) { is_expected.to match %r{hyperglass} }
    end
  end
end
