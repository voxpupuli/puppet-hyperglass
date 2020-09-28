require 'spec_helper'

describe 'hyperglass::agent' do
  let :node do
    'rspec.example.com'
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

        it { is_expected.to contain_class('hyperglass') }

        it {
          is_expected.to contain_file('/opt/hyperglass').with(
            {
              'ensure' => 'directory',
              'owner'  => 'root',
              'group'  => 'root',
              'mode'   => '0755',
            }
          )
        }
      end
    end
  end
end
