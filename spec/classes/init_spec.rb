# frozen_string_literal: true

require 'spec_helper'

describe 'logrotate' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts
        end

        context 'logrotate class without any parameters' do
          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('logrotate') }

          %w[install config params rules].each do |classs|
            it { is_expected.to contain_class("logrotate::#{classs}") }
          end

          case os_facts['os']['name']
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
                                                                             'owner'  => 'root',
                                                                             'group'  => 'wheel',
                                                                             'mode'   => '0755')

              is_expected.to contain_class('logrotate::defaults')
            end
          else

            it do
              is_expected.to contain_package('logrotate').with_ensure('present')

              is_expected.to contain_file('/etc/logrotate.d').with('ensure' => 'directory',
                                                                   'owner'  => 'root',
                                                                   'group'  => 'root',
                                                                   'mode'   => '0755')

              is_expected.to contain_class('logrotate::defaults')
            end

            if (os_facts['os']['family'] == 'RedHat' && os_facts['os']['release']['major'].to_i >= 9) ||
               (os_facts['os']['name']   == 'Ubuntu')
              it do
                is_expected.to contain_service('logrotate.timer').with(
                  'ensure' => 'running',
                  'enable' => true
                )

                is_expected.to contain_systemd__unit_file('logrotate-hourly.timer').with(
                  'ensure' => 'present',
                  'enable' => true,
                  'active' => true
                )

                is_expected.to contain_systemd__manage_dropin('hourly-timer.conf').with(
                  'ensure' => 'present',
                  'unit'   => 'logrotate-hourly.timer'
                )

                is_expected.to contain_systemd__unit_file('logrotate-hourly.service').with_ensure('present').without_enable.without_active

                is_expected.to contain_systemd__manage_dropin('hourly-service.conf').with(
                  'ensure' => 'present',
                  'unit' => 'logrotate-hourly.service',
                  'service_entry' => {
                    'ExecStart' => [
                      '',
                      '/usr/bin/flock --wait 21600 /run/lock/logrotate.service /usr/sbin/logrotate /etc/logrotate.d/hourly'
                    ]
                  }
                )

                is_expected.to contain_systemd__manage_dropin('logrotate-flock.conf').with(
                  'ensure' => 'present',
                  'unit' => 'logrotate.service',
                  'service_entry' => {
                    'ExecStart' => [
                      '',
                      '/usr/bin/flock --wait 21600 /run/lock/logrotate.service /usr/sbin/logrotate /etc/logrotate.conf'
                    ]
                  }
                )
              end
            else

              it do
                is_expected.to contain_file('/etc/cron.hourly/logrotate').with(
                  'ensure' => 'present',
                  'owner'  => 'root',
                  'group'  => 'root',
                  'mode'   => '0700'
                )

                is_expected.to contain_file('/etc/cron.daily/logrotate').with('ensure' => 'present',
                                                                              'owner' => 'root',
                                                                              'group' => 'root',
                                                                              'mode' => '0700')
              end

              it do
                is_expected.to contain_file('/etc/logrotate.d/hourly').with(
                  'ensure' => 'directory',
                  'owner'  => 'root',
                  'group'  => 'root',
                  'mode'   => '0755'
                )
              end

              it do
                is_expected.not_to contain_service('logrotate.timer')
                is_expected.not_to contain_systemd__unit_file('logrotate-hourly.timer')
                is_expected.not_to contain_systemd__unit_file('logrotate-hourly.service')
                is_expected.not_to contain_systemd__unit_file('logrotate-hourly.timer')
                is_expected.not_to contain_systemd__unit_file('logrotate-hourly.service')
                is_expected.not_to contain_systemd__manage_dropin('logrotate-flock.conf')
              end
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

          case os_facts['os']['name']
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

          case os_facts['os']['name']
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

          case os_facts['os']['name']
          when 'FreeBSD'
            it { is_expected.to contain_file('/usr/local/etc/logrotate.d/hourly').with_ensure('directory') }
          else
            it { is_expected.to contain_file('/etc/logrotate.d/hourly').with_ensure('directory') }
            it { is_expected.to contain_file('/etc/cron.hourly/logrotate').with_ensure('absent') }
          end
        end
      end
    end
  end
end
