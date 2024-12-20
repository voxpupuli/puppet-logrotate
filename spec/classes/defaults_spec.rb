# frozen_string_literal: true

require 'spec_helper'

describe 'logrotate' do
  let(:pre_condition) { 'class { "logrotate": }' }

  context 'no osfamily' do
    let(:facts) { { 'os' => { 'family' => 'fake' } } }

    it {
      is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
    }
  end

  on_supported_os.each do |os, os_facts|
    context os, if: os_facts['os']['family'] == 'Debian' do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_logrotate__conf('/etc/logrotate.conf') }

      it {
        is_expected.to contain_logrotate__rule('wtmp').with(
          'rotate_every' => 'monthly',
          'rotate' => 1,
          'create' => true,
          'create_mode' => '0664',
          'create_owner' => 'root',
          'create_group' => 'utmp',
          'missingok' => true
        )
      }

      it {
        is_expected.to contain_logrotate__rule('btmp').with(
          'rotate_every' => 'monthly',
          'rotate' => 1,
          'create' => true,
          'create_mode' => '0600',
          'create_owner' => 'root',
          'create_group' => 'utmp',
          'missingok' => true
        )
      }
    end

    context os, if: os_facts['os']['name'] == 'Ubuntu' do
      let(:facts) { os_facts }

      if os_facts['os']['release']['full'] == '18.04'
        it {
          is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with(
            'su_user' => 'root',
            'su_group' => 'syslog'
          )
        }
      end
      if os_facts['os']['release']['full'] == '22.04'
        it {
          is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with(
            'su_user' => 'root',
            'su_group' => 'adm'
          )
        }
      end
    end

    context os, if: os_facts['os']['family'] == 'RedHat' do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
      }

      it {
        is_expected.to contain_logrotate__rule('wtmp').with(
          'path' => '/var/log/wtmp',
          'create_mode' => '0664',
          'missingok' => facts['os']['release']['major'].to_i >= 8,
          'minsize' => '1M',
          'create' => true,
          'create_owner' => 'root',
          'create_group' => 'utmp',
          'rotate' => 1,
          'rotate_every' => 'monthly'
        )
      }

      it {
        is_expected.to contain_logrotate__rule('btmp').with(
          'path' => '/var/log/btmp',
          # 'create_mode' => '0600',
          # 'minsize' => '1M',
          'create' => true,
          'create_owner' => 'root',
          'create_group' => 'utmp',
          'rotate' => 1,
          'rotate_every' => 'monthly'
        )
      }
    end

    context os, if: os_facts['os']['family'] == 'Suse' do
      it {
        is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
      }

      it {
        is_expected.to contain_logrotate__rule('wtmp').with(
          'path' => '/var/log/wtmp',
          'create_mode' => '0664',
          'missingok' => false,
          'minsize' => '1M',
          'create' => true,
          'create_owner' => 'root',
          'create_group' => 'utmp',
          'maxage' => '365',
          'rotate' => 99,
          'rotate_every' => 'monthly',
          'size' => '400k'
        )
      }
    end

    context os, if: os_facts['os']['family'] == 'FreeBSD' do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_logrotate__conf('/usr/local/etc/logrotate.conf')
      }

      it {
        is_expected.to contain_logrotate__conf('/usr/local/etc/logrotate.conf').with(
          'su_user' => 'root',
          'su_group' => 'wheel'
        )
      }
    end
  end
end
