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

        it { is_expected.not_to contain_class('hyperglass::server') }

        it { is_expected.to contain_class('python').with_version('3').with_dev('present') }

        it { is_expected.to contain_package('gcc').with_ensure('installed') }

        it {
          is_expected.to contain_user('hyperglass-agent').with(
            {
              'ensure'         => 'present',
              'managehome'     => true,
              'purge_ssh_keys' => true,
              'system'         => true,
              'home'           => '/opt/hyperglass/hyperglass-agent',
            }
          )
        }

        it { is_expected.to contain_group('hyperglass-agent').with_ensure('present').with_system(true) }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-agent').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass-agent',
              'group'  => 'hyperglass-agent',
              'mode'   => '0700',
              'notify' => 'Systemd::Unit_file[hyperglass-agent.service]',
            }
          )
        }

        it {
          is_expected.to contain_python__pyvenv('/opt/hyperglass/hyperglass-agent/virtualenv').with(
            {
              'ensure'     => 'present',
              'owner'      => 'hyperglass-agent',
              'group'      => 'hyperglass-agent',
              'systempkgs' => false,
              'version'    => '3.6.8',
              'notify'     => 'Systemd::Unit_file[hyperglass-agent.service]',
            }
          )
        }

        it {
          is_expected.to contain_python__pip('hyperglass-agent').with(
            {
              'virtualenv' => '/opt/hyperglass/hyperglass-agent/virtualenv',
              'owner'      => 'hyperglass-agent',
              'group'      => 'hyperglass-agent',
              'notify'     => 'Systemd::Unit_file[hyperglass-agent.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-agent/hyperglass-agent').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass-agent',
              'group'  => 'hyperglass-agent',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass-agent.service]',
            }
          )
        }

        # The value for secret is constructed with fqdn_rand_string() and the
        # fqdn is specified at the top of this file.
        config_yaml_content = <<-END.gsub(%r{^\s+\|}, '')
          |---
          |debug: true
          |listen_address: 127.0.0.1
          |mode: bird
          |secret: zPWG9WEVHdqYpSPUHy2Z
          |ssl:
          |  enable: false
        END

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-agent/hyperglass-agent/config.yaml').with(
            {
              'ensure'  => 'file',
              'owner'   => 'hyperglass-agent',
              'group'   => 'hyperglass-agent',
              'mode'    => '0400',
              'content' => config_yaml_content,
              'notify'  => 'Systemd::Unit_file[hyperglass-agent.service]',
            }
          )
        }

        it {
          is_expected.to contain_systemd__unit_file('hyperglass-agent.service').with(
            {
              'source' => 'puppet:///modules/hyperglass/hyperglass-agent.service',
              'enable' => true,
              'active' => true,
            }
          )
        }
      end
    end
  end
end
