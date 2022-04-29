require 'spec_helper'

describe 'logrotate' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'logrotate class without any parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('logrotate') }
          %w[install config params rules].each do |classs|
            it { is_expected.to contain_class("logrotate::#{classs}") }
          end

          case facts[:operatingsystem]
          when 'FreeBSD'
            it do
              is_expected.to contain_file('/usr/local/etc/logrotate.d/hourly').with(
                'ensure' => 'directory',
                'owner'  => 'root',
                'group'  => 'wheel',
                'mode'   => '0755'
              )
            end

            it do
              is_expected.to contain_package('logrotate').with_ensure('present')

              is_expected.to contain_file('/usr/local/etc/logrotate.d').with('ensure' => 'directory',
                                                                             'owner'   => 'root',
                                                                             'group'   => 'wheel',
                                                                             'mode'    => '0755')

              is_expected.to contain_class('logrotate::defaults')
            end
          else
            it do
              is_expected.to contain_file('/etc/logrotate.d/hourly').with(
                'ensure' => 'directory',
                'owner'  => 'root',
                'group'  => 'root',
                'mode'   => '0755'
              )
            end

            it do
              is_expected.to contain_file('/etc/cron.hourly/logrotate').with(
                'ensure' => 'present',
                'owner'  => 'root',
                'group'  => 'root',
                'mode'   => '0700'
              )
            end

            it do
              is_expected.to contain_package('logrotate').with_ensure('present')

              is_expected.to contain_file('/etc/logrotate.d').with('ensure' => 'directory',
                                                                   'owner'   => 'root',
                                                                   'group'   => 'root',
                                                                   'mode'    => '0755')

              is_expected.to contain_file('/etc/cron.daily/logrotate').with('ensure' => 'present',
                                                                            'owner'   => 'root',
                                                                            'group'   => 'root',
                                                                            'mode'    => '0700')

              is_expected.to contain_class('logrotate::defaults')
            end
          end
        end

        context 'logrotate class with manage_package set to to false' do
          let(:params) { { manage_package: false } }

          it do
            is_expected.not_to contain_package('logrotate')
          end
        end

        context 'logrotate class with purge_configdir set to true' do
          let(:params) { { purge_configdir: true } }

          case facts[:operatingsystem]
          when 'FreeBSD'
            it do
              is_expected.to contain_file('/usr/local/etc/logrotate.d').with('ensure'  => 'directory',
                                                                             'owner'   => 'root',
                                                                             'group'   => 'wheel',
                                                                             'mode'    => '0755',
                                                                             'purge'   => true,
                                                                             'recurse' => true)
            end
          else
            it do
              is_expected.to contain_file('/etc/logrotate.d').with('ensure'  => 'directory',
                                                                   'owner'   => 'root',
                                                                   'group'   => 'root',
                                                                   'mode'    => '0755',
                                                                   'purge'   => true,
                                                                   'recurse' => true)
            end
          end
        end

        context 'logrotate class with create_base_rules set to to false' do
          let(:params) { { create_base_rules: false } }

          it do
            is_expected.not_to contain_logrotate__rule('btmp')
            is_expected.not_to contain_logrotate__rule('wtmp')
          end
        end

        context 'with config => { prerotate => "/usr/bin/test", rotate_every => "daily" }' do
          let(:params) { { config: { prerotate: '/usr/bin/test', rotate_every: 'daily' } } }

          case facts[:operatingsystem]
          when 'FreeBSD'
            it {
              is_expected.to contain_logrotate__conf('/usr/local/etc/logrotate.conf').
                with_prerotate('/usr/bin/test').
                with_rotate_every('daily')
            }
          else
            it {
              is_expected.to contain_logrotate__conf('/etc/logrotate.conf').
                with_prerotate('/usr/bin/test').
                with_rotate_every('daily')
            }
          end
        end

        context 'with ensure => absent' do
          let(:params) { { ensure_cron_hourly: 'absent' } }

          case facts[:operatingsystem]
          when 'FreeBSD'
            it { is_expected.to contain_file('/usr/local/etc/logrotate.d/hourly').with_ensure('absent') }
          else
            it { is_expected.to contain_file('/etc/logrotate.d/hourly').with_ensure('absent') }
            it { is_expected.to contain_file('/etc/cron.hourly/logrotate').with_ensure('absent') }
          end
        end
      end
    end
  end
end
