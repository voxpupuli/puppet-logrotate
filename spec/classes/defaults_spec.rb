require 'spec_helper'

describe 'logrotate' do

  context 'no osfamily' do
    let(:facts) { {:osfamily => 'fake'} }
    it {
      is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
    }
  end
  #Gentoo is special case, and doesn't show up in support_os
  # helper method despite being in metadata.json
  context 'Gentoo' do
    let(:facts) { {:osfamily => 'Gentoo'} }
    it {
      is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with(
          {
              'dateext' => true,
              'compress' => true,
              'ifempty' => false,
              'mail' => false,
              'olddir' => false,
          }
      )
    }
    it {
      is_expected.to contain_logrotate__rule('wtmp').with(
          {
              'path' => '/var/log/wtmp',
              'missingok' => false,
              'create_mode' => '0664',
              'minsize' => '1M',
              'rotate_every' => 'monthly',
              'create' => true,
              'create_owner' => 'root',
              'create_group' => 'utmp',
              'rotate' => 1,
          }
      )
    }
    it {
      is_expected.to contain_logrotate__rule('btmp').with(
          {
              'path' => '/var/log/btmp',
              'create_mode' => '0600',
              'missingok' => true,
              'rotate_every' => 'monthly',
              'create' => true,
              'create_owner' => 'root',
              'create_group' => 'utmp',
              'rotate' => 1,
          }
      )
    }
  end
  context 'SuSE' do
    let(:facts) { {:osfamily => 'SuSE'} }
    it {
      is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
    }
    it {
      is_expected.to contain_logrotate__rule('wtmp').with(
          {
              'path' => '/var/log/wtmp',
              'create_mode' => '0664',
              'missingok' => false,
              'create' => true,
              'create_owner' => 'root',
              'create_group' => 'utmp',
              'maxage' => 365,
              'rotate' => 99,
              'rotate_every' => 'monthly',
              'size' => '400k',
          }
      )
    }
    it {
      is_expected.to contain_logrotate__rule('btmp').with(
          {
              'path' => '/var/log/btmp',
              'create_mode' => '0600',
              'create' => true,
              'create_owner' => 'root',
              'create_group' => 'root',
              'maxage' => 365,
              'missingok' => true,
              'rotate' => 99,
              'rotate_every' => 'monthly',
              'size' => '400k',
          }
      )
    }
  end
  on_supported_os.each do |os, facts|
    context os, :if => facts[:osfamily] == 'Debian' do
      let(:facts) { facts }
      if (facts[:operatingsystem] == 'Ubuntu' and facts[:operatingsystemmajrelease].to_i >= 14)
        it {
          is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with_su_group('syslog')
        }
      else
        it {
          is_expected.to contain_logrotate__conf('/etc/logrotate.conf').with_su_group(nil)
        }
      end
      it {
        is_expected.to contain_logrotate__rule('wtmp').with(
            {
                'rotate_every' => 'monthly',
                'rotate' => '1',
                'create' => true,
                'create_mode' => '0664',
                'create_owner' => 'root',
                'create_group' => 'utmp',
                'missingok' => true,
            })
      }
      it {
        is_expected.to contain_logrotate__rule('btmp').with(
            {
                'rotate_every' => 'monthly',
                'rotate' => '1',
                'create' => true,
                'create_mode' => '0600',
                'create_owner' => 'root',
                'create_group' => 'utmp',
                'missingok' => true,
            })
      }
    end
    context os, :if => facts[:osfamily] == 'RedHat' do
      let(:facts) { facts }
      it {
        is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
      }
      it {
        is_expected.to contain_logrotate__rule('wtmp').with(
            {
                'path' => '/var/log/wtmp',
                'create_mode' => '0664',
                'missingok' => false,
                'minsize' => '1M',
                'create' => true,
                'create_owner' => 'root',
                'create_group' => 'utmp',
                'rotate' => 1,
                'rotate_every' => 'monthly',
            })
      }
      it {
        is_expected.to contain_logrotate__rule('btmp').with(
            {
                'path' => '/var/log/btmp',
                'create_mode' => '0600',
                'minsize' => '1M',
                'create' => true,
                'create_owner' => 'root',
                'create_group' => 'utmp',
                'rotate' => 1,
                'rotate_every' => 'monthly',
            })
      }
    end
    context os, :if => facts[:osfamily] == 'Suse' do
      it {
        is_expected.to contain_logrotate__conf('/etc/logrotate.conf')
      }
      it {
        is_expected.to contain_logrotate__rule('wtmp').with(
            {
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
                'size' => '400k',
            })
      }
    end

  end
end

