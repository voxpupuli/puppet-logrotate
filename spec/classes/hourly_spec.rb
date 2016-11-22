require 'spec_helper'

describe 'logrotate::hourly' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context 'with default values' do
          it do
            should contain_file('/etc/logrotate.d/hourly').with('ensure' => 'directory',
                                                                'owner'  => 'root',
                                                                'group'  => 'root',
                                                                'mode'   => '0755')
          end

          it do
            should contain_file('/etc/cron.hourly/logrotate').with('ensure' => 'present',
                                                                   'owner'   => 'root',
                                                                   'group'   => 'root',
                                                                   'mode'    => '0555',
                                                                   'source'  => 'puppet:///modules/logrotate/etc/cron.hourly/logrotate',
                                                                   'require' => [
                                                                     'File[/etc/logrotate.d/hourly]',
                                                                     'Package[logrotate]'
                                                                   ])
          end
        end

        context 'with ensure => absent' do
          let(:params) { { ensure: 'absent' } }

          it { should contain_file('/etc/logrotate.d/hourly').with_ensure('absent') }
          it { should contain_file('/etc/cron.hourly/logrotate').with_ensure('absent') }
        end

        context 'with ensure => foo' do
          let(:params) { { ensure: 'foo' } }

          it do
            expect do
              should contain_file('/etc/logrotate.d/hourly')
            end.to raise_error(Puppet::Error, %r{Invalid ensure value 'foo'})
          end
        end
      end
    end
  end
end
