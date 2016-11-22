require 'spec_helper'

describe '::logrotate::defaults' do
  context 'On supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end
        case facts[:operatingsystem]
        when 'Debian'
          it do
            is_expected.to contain_logrotate__rule('wtmp').with('rotate_every' => 'month',
                                                                'rotate'       => '1',
                                                                'create'       => true,
                                                                'create_mode'  => '0664',
                                                                'create_owner' => 'root',
                                                                'create_group' => 'utmp',
                                                                'missingok'    => true)

            is_expected.to contain_logrotate__rule('btmp').with('rotate_every' => 'month',
                                                                'rotate'       => '1',
                                                                'create'       => true,
                                                                'create_mode'  => '0600',
                                                                'create_owner' => 'root',
                                                                'create_group' => 'utmp',
                                                                'missingok'    => true)
          end
        end
      end
    end
  end
end
