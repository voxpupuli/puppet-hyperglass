require 'spec_helper'

describe 'hyperglass::server' do
  let :node do
    'rspec.puppet.com'
  end

  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts.merge(
          python3_version: '3.6.8'
        )
      end

      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('Hyperglass::Server::Config') }
        it { is_expected.to contain_class('Hyperglass::Server::Dependencies') }
        it { is_expected.to contain_class('Hyperglass::Server::Install') }
        it { is_expected.to contain_class('Hyperglass::Server::Service') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/commands.yaml').with_ensure('file').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/devices.yaml').with_ensure('file').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/hyperglass.yaml').with_ensure('file').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/custom').with_ensure('directory').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/images/favicons').with_ensure('directory').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/images').with_ensure('directory').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/ui').with_ensure('directory').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static').with_ensure('directory').with_owner('hyperglass').with_group('hyperglass') }
        it { is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass').with_ensure('directory').with_owner('hyperglass').with_group('hyperglass') }
      end
    end
  end
end
