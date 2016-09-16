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
            should contain_package('logrotate').with_ensure('present')

            #    should contain_file('/etc/logrotate.conf').with({
            #      'ensure'  => 'file',
            #      'owner'   => 'root',
            #      'group'   => 'root',
            #      'mode'    => '0444',
            #      'content' => 'template(\'logrotate/etc/logrotate.conf.erb\')',
            #      'source'  => 'puppet:///modules/logrotate/etc/logrotate.conf',
            #      'require' => 'Package[logrotate]',
            #    })

            should contain_file('/etc/logrotate.d').with('ensure' => 'directory',
                                                         'owner'   => 'root',
                                                         'group'   => 'root',
                                                         'mode'    => '0755')

            should contain_file('/etc/cron.daily/logrotate').with('ensure' => 'file',
                                                                  'owner'   => 'root',
                                                                  'group'   => 'root',
                                                                  'mode'    => '0555',
                                                                  'source'  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate')

            should contain_class('logrotate::defaults')
          end
        end

        context 'when other module installs logrotate' do
          let(:pre_condition) { 'ensure_packages("logrotate")' }
          it { is_expected.to compile.with_all_deps }
          it { should contain_package('logrotate').with_ensure('present') }
        end

        context 'with ensure => latest' do
          let(:params) { { ensure: 'latest' } }
          it { is_expected.to compile.with_all_deps }
          it { should contain_package('logrotate').with_ensure('latest') }
        end

        context 'when other module installs logrotate and we want to remove it' do
          let(:params) { { ensure: 'absent' } }
          let(:pre_condition) { 'package { "logrotate": ensure => present }' }
          it { is_expected.to raise_error(Puppet::Error, %r{Duplicate declaration}) }
        end
      end
    end
  end
end
