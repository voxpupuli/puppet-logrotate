# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'logrotate::rule' do
  context 'with ensure => present' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        file { '/var/log/acceptance':
          ensure => directory,
        }

        logrotate::rule { 'acceptance':
          path          => '/var/log/acceptance/weekly.log',
          rotate        => 4,
          rotate_every  => 'week',
          missingok     => true,
          ifempty       => false,
          compress      => true,
          delaycompress => true,
          sharedscripts => true,
          postrotate    => 'touch /var/log/acceptance/postrotate.ran',
        }

        logrotate::rule { 'acceptance_hourly':
          path         => '/var/log/acceptance/hourly.log',
          rotate       => 24,
          rotate_every => 'hour',
          missingok    => true,
        }
        PUPPET
      end
    end

    describe file('/etc/logrotate.d/acceptance') do
      it { is_expected.to be_file }
      it { is_expected.to be_mode 644 }
      its(:content) { is_expected.to match(%r{^/var/log/acceptance/weekly\.log \{$}) }

      %w[compress delaycompress missingok notifempty sharedscripts weekly].each do |directive|
        its(:content) { is_expected.to match(%r{^  #{directive}$}) }
      end

      its(:content) { is_expected.to match(%r{^  rotate 4$}) }
      its(:content) { is_expected.to match(%r{^  postrotate\n    touch /var/log/acceptance/postrotate\.ran\n  endscript$}) }
    end

    describe file('/etc/logrotate.d/hourly/acceptance_hourly') do
      it { is_expected.to be_file }
      its(:content) { is_expected.to match(%r{^  hourly$}) }
      its(:content) { is_expected.to match(%r{^  rotate 24$}) }
    end

    describe file('/etc/logrotate.d/acceptance_hourly') do
      it { is_expected.not_to exist }
    end

    %w[/etc/logrotate.conf /etc/logrotate.d/acceptance /etc/logrotate.d/hourly].each do |config|
      describe command("logrotate -d #{config}") do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.not_to match(%r{error}i) }
        its(:stderr) { is_expected.not_to match(%r{error}i) }
      end
    end

    # Two forced runs: delaycompress leaves .1 plain and compresses .2
    describe command(<<~SHELL) do
      set -e
      rm -f /var/log/acceptance/weekly.log* /var/log/acceptance/postrotate.ran
      for i in 1 2; do
        echo "run $i" > /var/log/acceptance/weekly.log
        logrotate -f -s /var/tmp/acceptance.state /etc/logrotate.d/acceptance
      done
      ls /var/log/acceptance
    SHELL
      its(:exit_status) { is_expected.to eq 0 }
      its(:stdout) { is_expected.to match(%r{^weekly\.log\.1$}) }
      its(:stdout) { is_expected.to match(%r{^weekly\.log\.2\.gz$}) }
      its(:stdout) { is_expected.to match(%r{^postrotate\.ran$}) }
    end
  end

  context 'with ensure => absent' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        logrotate::rule { 'acceptance':
          ensure => absent,
        }

        logrotate::rule { 'acceptance_hourly':
          ensure       => absent,
          rotate_every => 'hour',
        }
        PUPPET
      end
    end

    %w[/etc/logrotate.d/acceptance /etc/logrotate.d/hourly/acceptance_hourly].each do |path|
      describe file(path) do
        it { is_expected.not_to exist }
      end
    end
  end
end
