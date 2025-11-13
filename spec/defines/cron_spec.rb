# frozen_string_literal: true

require 'spec_helper'

describe 'logrotate::cron' do
  context 'supported operating systems' do
    let(:pre_condition) { 'class { "logrotate": }' }

    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts
        end

        context 'With default params' do
          let(:title) { 'test' }
          let(:params) { { ensure: 'present' } }

          if os_facts['os']['family'] == 'FreeBSD'
            it {
              is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
                with_ensure('present').
                with_content(%r{(/usr/local/sbin/logrotate /usr/local/etc/logrotate.conf 2>&1)})
            }
          else
            it {
              is_expected.to contain_file('/etc/cron.test/logrotate').
                with_ensure('present').
                with_content(%r{(/usr/sbin/logrotate /etc/logrotate.conf 2>&1)})
            }
          end
        end

        context 'With additional arguments' do
          let(:pre_condition) { 'class {"logrotate": logrotate_args => ["-s /var/lib/logrotate/logrotate.status", "-m /usr/sbin/mailer"]}' }
          let(:title) { 'test' }
          let(:params) { { ensure: 'present' } }

          if os_facts['os']['family'] == 'FreeBSD'
            it {
              is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
                with_ensure('present').
                with_content(%r{(/usr/local/sbin/logrotate -s /var/lib/logrotate/logrotate.status -m /usr/sbin/mailer /usr/local/etc/logrotate.conf 2>&1)})
            }
          else
            it {
              is_expected.to contain_file('/etc/cron.test/logrotate').
                with_ensure('present').
                with_content(%r{(/usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status -m /usr/sbin/mailer /etc/logrotate.conf 2>&1)})
            }
          end
        end
      end
    end

    # Test FreeBSD separately as it is only partially supported by the module and not in the list of supported os.
    # When FreeBSD is added to the list of supported systems, these tests can be removed as they are already part of the test set above.
    context 'on FreeBDS' do
      let(:facts) { { 'os' => { 'family' => 'FreeBSD' } } }

      context 'With default params' do
        let(:title) { 'test' }
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
            with_ensure('present').
            with_content(%r{(/usr/local/sbin/logrotate /usr/local/etc/logrotate.conf 2>&1)})
        }
      end

      context 'With additional arguments and status' do
        let(:pre_condition) { 'class {"logrotate": logrotate_args => ["-s /var/lib/logrotate/logrotate.status", "-m /usr/sbin/mailer"]}' }
        let(:title) { 'test' }
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
            with_ensure('present').
            with_content(%r{(/usr/local/sbin/logrotate -s /var/lib/logrotate/logrotate.status -m /usr/sbin/mailer /usr/local/etc/logrotate.conf 2>&1)})
        }
      end

      context 'With additional arguments' do
        let(:pre_condition) { 'class {"logrotate": cron_always_output => true}' }
        let(:title) { 'test' }
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
            with_ensure('present').
            with_content(%r{(else\n    echo "\${OUTPUT}"\nfi)})
        }
      end

      context 'With title daily (FreeBSD cron resource test)' do
        let(:pre_condition) { 'class { "logrotate": manage_cron_daily => false }' }
        let(:title) { 'daily' }
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_cron('logrotate_daily').with(
            'minute' => 0,
            'hour' => 1,
            'command' => '/usr/local/bin/logrotate.daily.sh',
            'user' => 'root'
          )
        }

        it {
          is_expected.to contain_file('/usr/local/bin/logrotate.daily.sh').
            with_ensure('present').
            with_content(%r{(/usr/local/sbin/logrotate /usr/local/etc/logrotate.conf 2>&1)})
        }
      end

      context 'With title hourly (FreeBSD cron resource test)' do
        let(:pre_condition) { 'class { "logrotate": manage_cron_hourly => false }' }
        let(:title) { 'hourly' }
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_cron('logrotate_hourly').with(
            'minute' => 1,
            'hour' => '*',
            'command' => '/usr/local/bin/logrotate.hourly.sh',
            'user' => 'root'
          )
        }

        it {
          is_expected.to contain_file('/usr/local/bin/logrotate.hourly.sh').
            with_ensure('present').
            with_content(%r{(/usr/local/sbin/logrotate /usr/local/etc/logrotate.d/hourly 2>&1)})
        }
      end

      context 'With custom title test (FreeBSD cron resource test)' do
        let(:pre_condition) { 'class { "logrotate": }' }
        let(:title) { 'test' }
        let(:params) { { ensure: 'present' } }

        it {
          is_expected.to contain_cron('logrotate_test').with(
            'user' => 'root'
          )
        }

        it {
          is_expected.to contain_file('/usr/local/bin/logrotate.test.sh').
            with_ensure('present')
        }
      end
    end
  end
end
