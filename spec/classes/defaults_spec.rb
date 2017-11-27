require 'spec_helper'

describe 'logrotate' do
  let(:pre_condition) { 'class { "::logrotate": }' }

  context 'no osfamily' do
    let(:facts) { { osfamily: 'fake' } }

    it {
      is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
    }
  end
  on_supported_os.each do |os, facts|
    context os, if: facts[:osfamily] == 'Debian' do
      let(:facts) { facts }

      if facts[:operatingsystem] == 'Ubuntu' && facts[:operatingsystemmajrelease].to_i >= 14
        it {
          is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with(
            'su_owner' => 'root',
            'su_group' => 'syslog'
          )
        }
      else
        it {
          is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with(
            'su_owner' => nil,
            'su_group' => nil
          )
        }
      end
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
    context os, if: facts[:osfamily] == 'RedHat' do
      let(:facts) { facts }

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
    context os, if: facts[:osfamily] == 'Suse' do
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
  end
end
