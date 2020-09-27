require 'spec_helper'

describe 'hyperglass::server' do
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

        it { is_expected.not_to contain_class('hyperglass::agent') }

        it { is_expected.to contain_class('nginx') }

        it { is_expected.to contain_class('python').with_version('3').with_dev('present') }

        it { is_expected.to contain_package('gcc').with_ensure('installed') }

        it { is_expected.to contain_class('redis::globals').with_scl('rh-redis5').that_comes_before('Class[Redis]') }

        it { is_expected.to contain_class('redis').with_manage_repo(true) }

        it {
          is_expected.to contain_yumrepo('yarn').with(
            {
              'ensure'   => 'present',
              'baseurl'  => 'https://dl.yarnpkg.com/rpm/',
              'gpgcheck' => 1,
              'gpgkey'   => 'https://dl.yarnpkg.com/rpm/pubkey.gpg',
              'descr'    => 'Yarn Repository',
            }
          )
        }

        it { is_expected.to contain_package('yarn').with_ensure('present').that_requires('Yumrepo[yarn]') }

        it {
          is_expected.to contain_user('hyperglass').with(
            {
              'ensure'         => 'present',
              'managehome'     => true,
              'purge_ssh_keys' => true,
              'system'         => true,
              'home'           => '/opt/hyperglass/hyperglass-server',
            }
          )
        }

        it { is_expected.to contain_group('hyperglass').with_ensure('present').with_system(true) }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass',
              'group'  => 'hyperglass',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass',
              'group'  => 'hyperglass',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/custom').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass',
              'group'  => 'hyperglass',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/ui').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass',
              'group'  => 'hyperglass',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/images').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass',
              'group'  => 'hyperglass',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/static/images/favicons').with(
            {
              'ensure' => 'directory',
              'owner'  => 'hyperglass',
              'group'  => 'hyperglass',
              'mode'   => '0755',
              'notify' => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_python__pyvenv('/opt/hyperglass/hyperglass-server/virtualenv').with(
            {
              'ensure'     => 'present',
              'owner'      => 'hyperglass',
              'group'      => 'hyperglass',
              'systempkgs' => false,
              'version'    => '3.6.8',
              'notify'     => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_python__pip('hyperglass').with(
            {
              'virtualenv' => '/opt/hyperglass/hyperglass-server/virtualenv',
              'owner'      => 'hyperglass',
              'group'      => 'hyperglass',
              'notify'     => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/hyperglass.yaml').with(
            {
              'ensure'  => 'file',
              'owner'   => 'hyperglass',
              'group'   => 'hyperglass',
              'mode'    => '0644',
              'content' => "--- {}\n",
              'notify'  => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/commands.yaml').with(
            {
              'ensure'  => 'file',
              'owner'   => 'hyperglass',
              'group'   => 'hyperglass',
              'mode'    => '0644',
              'content' => "--- {}\n",
              'notify'  => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_file('/opt/hyperglass/hyperglass-server/hyperglass/devices.yaml').with(
            {
              'ensure'  => 'file',
              'owner'   => 'hyperglass',
              'group'   => 'hyperglass',
              'mode'    => '0644',
              'content' => "--- {}\n",
              'notify'  => 'Systemd::Unit_file[hyperglass.service]',
            }
          )
        }

        it {
          is_expected.to contain_systemd__unit_file('hyperglass.service').with(
            {
              'source' => 'puppet:///modules/hyperglass/hyperglass.service',
              'enable' => true,
              'active' => true,
            }
          )
        }
      end
    end
  end
end
