# frozen_string_literal: true

require 'spec_helper'

describe 'logrotate::cron' do
  context 'supported operating systems' do
    let(:pre_condition) { 'class { "::logrotate": }' }

    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'With default params' do
          let(:title) { 'test' }
          let(:params) { { ensure: 'present' } }

          if facts[:osfamily] == 'FreeBSD'
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
          let(:pre_condition) { 'class {"::logrotate": logrotate_args => ["-s /var/lib/logrotate/logrotate.status", "-m /usr/sbin/mailer"]}' }
          let(:title) { 'test' }
          let(:params) { { ensure: 'present' } }

          if facts[:osfamily] == 'FreeBSD'
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
  end
end
