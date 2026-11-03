# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'logrotate class' do
  # Module data defaults Ubuntu and EL9+ to systemd timers, everything else to cron
  systemd_timer = fact('os.name') == 'Ubuntu' || (fact('os.family') == 'RedHat' && fact('os.release.major').to_i >= 9)

  context 'default parameters' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) { "class { 'logrotate': }" }
    end

    if systemd_timer
      %w[logrotate.timer logrotate-hourly.timer].each do |timer|
        describe service(timer) do
          it { is_expected.to be_enabled }
          it { is_expected.to be_running }
        end
      end

      %w[logrotate.service logrotate-hourly.service].each do |unit|
        describe command("systemctl start #{unit}") do
          its(:exit_status) { is_expected.to eq 0 }
        end
      end

      %w[daily hourly].each do |period|
        describe file("/etc/cron.#{period}/logrotate") do
          it { is_expected.not_to exist }
        end
      end
    else
      %w[daily hourly].each do |period|
        describe file("/etc/cron.#{period}/logrotate") do
          it { is_expected.to be_file }
          it { is_expected.to be_mode 700 }
        end

        describe command("/etc/cron.#{period}/logrotate") do
          its(:exit_status) { is_expected.to eq 0 }
        end
      end
    end
  end

  if systemd_timer
    context 'with cron instead of systemd timers' do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          # Provides /etc/cron.hourly, which minimal images lack
          package { $facts['os']['family'] ? { 'RedHat' => 'cronie', default => 'cron' }:
            ensure => installed,
            before => Class['logrotate'],
          }

          class { 'logrotate':
            ensure_cron_daily           => 'present',
            ensure_cron_hourly          => 'present',
            ensure_systemd_timer        => 'absent',
            ensure_systemd_timer_hourly => 'absent',
          }
          PUPPET
        end
      end

      describe service('logrotate.timer') do
        it { is_expected.not_to be_enabled }
        it { is_expected.not_to be_running }
      end

      %w[
        /etc/systemd/system/logrotate-hourly.timer
        /etc/systemd/system/logrotate-hourly.service
        /etc/systemd/system/logrotate.service.d/logrotate-flock.conf
      ].each do |path|
        describe file(path) do
          it { is_expected.not_to exist }
        end
      end

      %w[daily hourly].each do |period|
        describe file("/etc/cron.#{period}/logrotate") do
          it { is_expected.to be_file }
          it { is_expected.to be_mode 700 }
        end

        describe command("/etc/cron.#{period}/logrotate") do
          its(:exit_status) { is_expected.to eq 0 }
        end
      end
    end
  end
end
