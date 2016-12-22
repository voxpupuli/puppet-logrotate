require 'spec_helper'
require 'shared_examples'

describe 'logrotate::hourly' do
  context 'with default values' do
    it {
      is_expected.to contain_file('/etc/logrotate.d/hourly').with(
          {
              'ensure' => 'directory',
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0755',
          })
    }

    it {
      is_expected.to contain_file('/etc/cron.hourly/logrotate').with(
          {
              'ensure' => 'present',
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0555',
              'source' => 'puppet:///modules/logrotate/etc/cron.hourly/logrotate',
              'require' => [
                  'File[/etc/logrotate.d/hourly]',
                  'Package[logrotate]'
              ],
          }
      )
    }
  end

  context 'with ensure => absent' do
    let(:params) { {ensure: 'absent'} }

    it { is_expected.to contain_file('/etc/logrotate.d/hourly').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.hourly/logrotate').with_ensure('absent') }
  end

  context 'with ensure => foo' do
    include_context 'config file' do
      let(:config_file) { '/etc/cron.hourly/logrotate' }
    end
    it_behaves_like 'error match', 'ensure', 'Enum'
  end
end
