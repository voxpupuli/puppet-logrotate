require 'spec_helper'

describe 'logrotate' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'logrotate class without any parameters' do
          let(:params) { {} }

          it { is_expected.to compile.with_all_deps }

          it do
            is_expected.to contain_package('logrotate').with_ensure('present')

            #    should contain_file('/etc/logrotate.conf').with({
            #      'ensure'  => 'file',
            #      'owner'   => 'root',
            #      'group'   => 'root',
            #      'mode'    => '0444',
            #      'content' => 'template(\'logrotate/etc/logrotate.conf.erb\')',
            #      'source'  => 'puppet:///modules/logrotate/etc/logrotate.conf',
            #      'require' => 'Package[logrotate]',
            #    })

            is_expected.to contain_file('/etc/logrotate.d').with('ensure' => 'directory',
                                                                 'owner'   => 'root',
                                                                 'group'   => 'root',
                                                                 'mode'    => '0755')

            is_expected.to contain_file('/etc/cron.daily/logrotate').with('ensure' => 'file',
                                                                          'owner'   => 'root',
                                                                          'group'   => 'root',
                                                                          'mode'    => '0555',
                                                                          'source'  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate')

            is_expected.to contain_class('logrotate::defaults')
          end
        end
      end
    end
  end
end
