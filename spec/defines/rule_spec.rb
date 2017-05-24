require 'spec_helper'

describe 'logrotate::rule' do
  context 'Not a real operating system, with minimal facts set to prevent errors' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        lsbdistrelease: 'Imaginary'
      }
    end
    context 'with an alphanumeric title' do
      let(:title) { 'test' }

      context 'and ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it do
          is_expected.to contain_file('/etc/logrotate.d/test').with_ensure('absent')
        end
      end

      let(:params) { { path: '/var/log/foo.log' } }
      it do
        is_expected.to contain_class('logrotate')
        is_expected.to contain_file('/etc/logrotate.d/test').with('owner' => 'root',
                                                                  'group'   => 'root',
                                                                  'ensure'  => 'present',
                                                                  'mode'    => '0444').with_content(%r{^/var/log/foo\.log \{\n\}\n})
      end

      context 'with an array path' do
        let(:params) { { path: ['/var/log/foo1.log', '/var/log/foo2.log'] } }
        it do
          is_expected.to contain_file('/etc/logrotate.d/test').with_content(
            %r{/var/log/foo1\.log /var/log/foo2\.log \{\n\}\n}
          )
        end
      end

      ###########################################################################
      # COMPRESS
      context 'and compress => true' do
        let(:params) do
          { path: '/var/log/foo.log', compress: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  compress$})
        end
      end

      context 'and compress => false' do
        let(:params) do
          { path: '/var/log/foo.log', compress: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nocompress$})
        end
      end

      context 'and compress => foo' do
        let(:params) do
          { path: '/var/log/foo.log', compress: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{compress must be a boolean})
        end
      end

      ###########################################################################
      # COMPRESSCMD
      context 'and compresscmd => bzip2' do
        let(:params) do
          { path: '/var/log/foo.log', compresscmd: 'bzip2' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  compresscmd bzip2$})
        end
      end

      ###########################################################################
      # COMPRESSEXT
      context 'and compressext => .bz2' do
        let(:params) do
          { path: '/var/log/foo.log', compressext: '.bz2' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  compressext .bz2$})
        end
      end

      ###########################################################################
      # COMPRESSOPTIONS
      context 'and compressoptions => -9' do
        let(:params) do
          { path: '/var/log/foo.log', compressoptions: '-9' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  compressoptions -9$})
        end
      end

      ###########################################################################
      # COPY
      context 'and copy => true' do
        let(:params) do
          { path: '/var/log/foo.log', copy: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test').with_content(%r{^  copy$})
        end
      end

      context 'and copy => false' do
        let(:params) do
          { path: '/var/log/foo.log', copy: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test').with_content(%r{^  nocopy$})
        end
      end

      context 'and copy => foo' do
        let(:params) do
          { path: '/var/log/foo.log', copy: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{copy must be a boolean})
        end
      end

      ###########################################################################
      # COPYTRUNCATE
      context 'and copytruncate => true' do
        let(:params) do
          { path: '/var/log/foo.log', copytruncate: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  copytruncate$})
        end
      end

      context 'and copytruncate => false' do
        let(:params) do
          { path: '/var/log/foo.log', copytruncate: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nocopytruncate$})
        end
      end

      context 'and copytruncate => foo' do
        let(:params) do
          { path: '/var/log/foo.log', copytruncate: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{copytruncate must be a boolean})
        end
      end

      ###########################################################################
      # CREATE / CREATE_MODE / CREATE_OWNER / CREATE_GROUP
      context 'and create => true' do
        let(:params) do
          { path: '/var/log/foo.log', create: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  create$})
        end

        context 'and create_mode => 0777' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              create: true,
              create_mode: '0777'
            }
          end

          it do
            is_expected.to contain_file('/etc/logrotate.d/test'). \
              with_content(%r{^  create 0777$})
          end

          context 'and create_owner => www-data' do
            let(:params) do
              {
                path: '/var/log/foo.log',
                create: true,
                create_mode: '0777',
                create_owner: 'www-data'
              }
            end

            it do
              is_expected.to contain_file('/etc/logrotate.d/test'). \
                with_content(%r{^  create 0777 www-data})
            end

            context 'and create_group => admin' do
              let(:params) do
                {
                  path: '/var/log/foo.log',
                  create: true,
                  create_mode: '0777',
                  create_owner: 'www-data',
                  create_group: 'admin'
                }
              end

              it do
                is_expected.to contain_file('/etc/logrotate.d/test'). \
                  with_content(%r{^  create 0777 www-data admin$})
              end
            end
          end

          context 'and create_group => admin' do
            let(:params) do
              {
                path: '/var/log/foo.log',
                create: true,
                create_mode: '0777',
                create_group: 'admin'
              }
            end

            it do
              expect do
                is_expected.to contain_file('/etc/logrotate.d/test')
              end.to raise_error(Puppet::Error, %r{create_group requires create_owner})
            end
          end
        end

        context 'and create_owner => www-data' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              create: true,
              create_owner: 'www-data'
            }
          end

          it do
            expect do
              is_expected.to contain_file('/etc/logrotate.d/test')
            end.to raise_error(Puppet::Error, %r{create_owner requires create_mode})
          end
        end
      end

      context 'and create => false' do
        let(:params) do
          { path: '/var/log/foo.log', create: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nocreate$})
        end

        context 'and create_mode => 0777' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              create: false,
              create_mode: '0777'
            }
          end

          it do
            expect do
              is_expected.to contain_file('/etc/logrotate.d/test')
            end.to raise_error(Puppet::Error, %r{create_mode requires create})
          end
        end
      end

      context 'and create => foo' do
        let(:params) do
          { path: '/var/log/foo.log', create: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{create must be a boolean})
        end
      end

      ###########################################################################
      # DATEEXT
      context 'and dateext => true' do
        let(:params) do
          { path: '/var/log/foo.log', dateext: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  dateext$})
        end
      end

      context 'and dateext => false' do
        let(:params) do
          { path: '/var/log/foo.log', dateext: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nodateext$})
        end
      end

      context 'and dateext => foo' do
        let(:params) do
          { path: '/var/log/foo.log', dateext: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{dateext must be a boolean})
        end
      end

      ###########################################################################
      # DATEFORMAT
      context 'and dateformat => -%Y%m%d' do
        let(:params) do
          { path: '/var/log/foo.log', dateformat: '-%Y%m%d' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  dateformat -%Y%m%d$})
        end
      end

      ###########################################################################
      # DELAYCOMPRESS
      context 'and delaycompress => true' do
        let(:params) do
          { path: '/var/log/foo.log', delaycompress: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  delaycompress$})
        end
      end

      context 'and delaycompress => false' do
        let(:params) do
          { path: '/var/log/foo.log', delaycompress: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nodelaycompress$})
        end
      end

      context 'and delaycompress => foo' do
        let(:params) do
          { path: '/var/log/foo.log', delaycompress: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{delaycompress must be a boolean})
        end
      end

      ###########################################################################
      # EXTENSION
      context 'and extension => foo' do
        let(:params) do
          { path: '/var/log/foo.log', extension: '.foo' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  extension \.foo$})
        end
      end

      ###########################################################################
      # IFEMPTY
      context 'and ifempty => true' do
        let(:params) do
          { path: '/var/log/foo.log', ifempty: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  ifempty$})
        end
      end

      context 'and ifempty => false' do
        let(:params) do
          { path: '/var/log/foo.log', ifempty: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  notifempty$})
        end
      end

      context 'and ifempty => foo' do
        let(:params) do
          { path: '/var/log/foo.log', ifempty: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{ifempty must be a boolean})
        end
      end

      ###########################################################################
      # MAIL / MAILFIRST / MAILLAST
      context 'and mail => test.example.com' do
        let(:params) do
          { path: '/var/log/foo.log', mail: 'test@example.com' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  mail test@example.com$})
        end

        context 'and mailfirst => true' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              mail: 'test@example.com',
              mailfirst: true
            }
          end

          it do
            is_expected.to contain_file('/etc/logrotate.d/test'). \
              with_content(%r{^  mailfirst$})
          end

          context 'and maillast => true' do
            let(:params) do
              {
                path: '/var/log/foo.log',
                mail: 'test@example.com',
                mailfirst: true,
                maillast: true
              }
            end

            it do
              expect do
                is_expected.to contain_file('/etc/logrotate.d/test')
              end.to raise_error(Puppet::Error, %r{set both mailfirst and maillast})
            end
          end
        end

        context 'and maillast => true' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              mail: 'test@example.com',
              maillast: true
            }
          end

          it do
            is_expected.to contain_file('/etc/logrotate.d/test'). \
              with_content(%r{^  maillast$})
          end
        end
      end

      context 'and mail => false' do
        let(:params) do
          { path: '/var/log/foo.log', mail: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nomail$})
        end
      end

      ###########################################################################
      # MAXAGE
      context 'and maxage => 3' do
        let(:params) do
          { path: '/var/log/foo.log', maxage: 3 }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  maxage 3$})
        end
      end

      context 'and maxage => foo' do
        let(:params) do
          { path: '/var/log/foo.log', maxage: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{maxage must be an integer})
        end
      end

      ###########################################################################
      # MINSIZE
      context 'and minsize => 100' do
        let(:params) do
          { path: '/var/log/foo.log', minsize: 100 }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  minsize 100$})
        end
      end

      context 'and minsize => 100k' do
        let(:params) do
          { path: '/var/log/foo.log', minsize: '100k' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  minsize 100k$})
        end
      end

      context 'and minsize => 100M' do
        let(:params) do
          { path: '/var/log/foo.log', minsize: '100M' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  minsize 100M$})
        end
      end

      context 'and minsize => 100G' do
        let(:params) do
          { path: '/var/log/foo.log', minsize: '100G' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  minsize 100G$})
        end
      end

      context 'and minsize => foo' do
        let(:params) do
          { path: '/var/log/foo.log', minsize: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{minsize must match})
        end
      end

      ###########################################################################
      # MISSINGOK
      context 'and missingok => true' do
        let(:params) do
          { path: '/var/log/foo.log', missingok: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  missingok$})
        end
      end

      context 'and missingok => false' do
        let(:params) do
          { path: '/var/log/foo.log', missingok: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nomissingok$})
        end
      end

      context 'and missingok => foo' do
        let(:params) do
          { path: '/var/log/foo.log', missingok: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{missingok must be a boolean})
        end
      end

      ###########################################################################
      # OLDDIR
      context 'and olddir => /var/log/old' do
        let(:params) do
          { path: '/var/log/foo.log', olddir: '/var/log/old' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  olddir \/var\/log\/old$})
        end
      end

      context 'and olddir => false' do
        let(:params) do
          { path: '/var/log/foo.log', olddir: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  noolddir$})
        end
      end

      ###########################################################################
      # POSTROTATE
      context 'and postrotate => /bin/true' do
        let(:params) do
          { path: '/var/log/foo.log', postrotate: '/bin/true' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{postrotate\n    \/bin\/true\n  endscript})
        end
      end

      context "and postrotate => ['/bin/true', '/bin/false']" do
        let(:params) do
          { path: '/var/log/foo.log', postrotate: ['/bin/true', '/bin/false'] }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{postrotate\n    \/bin\/true\n    \/bin\/false\n  endscript})
        end
      end

      ###########################################################################
      # PREROTATE
      context 'and prerotate => /bin/true' do
        let(:params) do
          { path: '/var/log/foo.log', prerotate: '/bin/true' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{prerotate\n    \/bin\/true\n  endscript})
        end
      end

      context "and prerotate => ['/bin/true', '/bin/false']" do
        let(:params) do
          { path: '/var/log/foo.log', prerotate: ['/bin/true', '/bin/false'] }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{prerotate\n    \/bin\/true\n    \/bin\/false\n  endscript})
        end
      end

      ###########################################################################
      # FIRSTACTION
      context 'and firstaction => /bin/true' do
        let(:params) do
          { path: '/var/log/foo.log', firstaction: '/bin/true' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{firstaction\n    \/bin\/true\n  endscript})
        end
      end

      context "and firstaction => ['/bin/true', '/bin/false']" do
        let(:params) do
          { path: '/var/log/foo.log', firstaction: ['/bin/true', '/bin/false'] }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{firstaction\n    \/bin\/true\n    \/bin\/false\n  endscript})
        end
      end

      ###########################################################################
      # LASTACTION
      context 'and lastaction => /bin/true' do
        let(:params) do
          { path: '/var/log/foo.log', lastaction: '/bin/true' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{lastaction\n    \/bin\/true\n  endscript})
        end
      end

      context "and lastaction => ['/bin/true', '/bin/false']" do
        let(:params) do
          { path: '/var/log/foo.log', lastaction: ['/bin/true', '/bin/false'] }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{lastaction\n    \/bin\/true\n    \/bin\/false\n  endscript})
        end
      end

      ###########################################################################
      # ROTATE
      context 'and rotate => 3' do
        let(:params) do
          { path: '/var/log/foo.log', rotate: 3 }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  rotate 3$})
        end
      end

      context 'and rotate => foo' do
        let(:params) do
          { path: '/var/log/foo.log', rotate: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{rotate must be an integer})
        end
      end

      ###########################################################################
      # ROTATE_EVERY
      context 'and rotate_every => hour' do
        let(:params) do
          { path: '/var/log/foo.log', rotate_every: 'hour' }
        end

        it { is_expected.to contain_class('logrotate::hourly') }
        it { is_expected.to contain_file('/etc/logrotate.d/hourly/test') }
        it { is_expected.to contain_file('/etc/logrotate.d/test').with_ensure('absent') }
      end

      context 'and rotate_every => day' do
        let(:params) do
          { path: '/var/log/foo.log', rotate_every: 'day' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  daily$})
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/hourly/test'). \
            with_ensure('absent')
        end
      end

      context 'and rotate_every => week' do
        let(:params) do
          { path: '/var/log/foo.log', rotate_every: 'week' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  weekly$})
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/hourly/test'). \
            with_ensure('absent')
        end
      end

      context 'and rotate_every => month' do
        let(:params) do
          { path: '/var/log/foo.log', rotate_every: 'month' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  monthly$})
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/hourly/test'). \
            with_ensure('absent')
        end
      end

      context 'and rotate_every => year' do
        let(:params) do
          { path: '/var/log/foo.log', rotate_every: 'year' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  yearly$})
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/hourly/test'). \
            with_ensure('absent')
        end
      end

      context 'and rotate_every => foo' do
        let(:params) do
          { path: '/var/log/foo.log', rotate_every: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{invalid rotate_every value})
        end
      end

      ###########################################################################
      # SIZE
      context 'and size => 100' do
        let(:params) do
          { path: '/var/log/foo.log', size: 100 }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  size 100$})
        end
      end

      context 'and size => 100k' do
        let(:params) do
          { path: '/var/log/foo.log', size: '100k' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  size 100k$})
        end
      end

      context 'and size => 100M' do
        let(:params) do
          { path: '/var/log/foo.log', size: '100M' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  size 100M$})
        end
      end

      context 'and size => 100G' do
        let(:params) do
          { path: '/var/log/foo.log', size: '100G' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  size 100G$})
        end
      end

      context 'and size => foo' do
        let(:params) do
          { path: '/var/log/foo.log', size: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{size must match})
        end
      end

      ###########################################################################
      # SHAREDSCRIPTS
      context 'and sharedscripts => true' do
        let(:params) do
          { path: '/var/log/foo.log', sharedscripts: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  sharedscripts$})
        end
      end

      context 'and sharedscripts => false' do
        let(:params) do
          { path: '/var/log/foo.log', sharedscripts: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  nosharedscripts$})
        end
      end

      context 'and sharedscripts => foo' do
        let(:params) do
          { path: '/var/log/foo.log', sharedscripts: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{sharedscripts must be a boolean})
        end
      end

      ###########################################################################
      # SHRED / SHREDCYCLES
      context 'and shred => true' do
        let(:params) do
          { path: '/var/log/foo.log', shred: true }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  shred$})
        end

        context 'and shredcycles => 3' do
          let(:params) do
            { path: '/var/log/foo.log', shred: true, shredcycles: 3 }
          end

          it do
            is_expected.to contain_file('/etc/logrotate.d/test'). \
              with_content(%r{^  shredcycles 3$})
          end
        end

        context 'and shredcycles => foo' do
          let(:params) do
            { path: '/var/log/foo.log', shred: true, shredcycles: 'foo' }
          end

          it do
            expect do
              is_expected.to contain_file('/etc/logrotate.d/test')
            end.to raise_error(Puppet::Error, %r{shredcycles must be an integer})
          end
        end
      end

      context 'and shred => false' do
        let(:params) do
          { path: '/var/log/foo.log', shred: false }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  noshred$})
        end
      end

      context 'and shred => foo' do
        let(:params) do
          { path: '/var/log/foo.log', shred: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{shred must be a boolean})
        end
      end

      ###########################################################################
      # START
      context 'and start => 0' do
        let(:params) do
          { path: '/var/log/foo.log', start: 0 }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  start 0$})
        end
      end

      context 'and start => foo' do
        let(:params) do
          { path: '/var/log/foo.log', start: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{start must be an integer})
        end
      end

      ###########################################################################
      # SU / SU_OWNER / SU_GROUP
      context 'and su => true' do
        let(:params) do
          { path: '/var/log/foo.log', su: true }
        end

        context 'and su_owner => www-data' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              su: true,
              su_owner: 'www-data'
            }
          end

          it do
            is_expected.to contain_file('/etc/logrotate.d/test'). \
              with_content(%r{^  su www-data})
          end

          context 'and su_group => admin' do
            let(:params) do
              {
                path: '/var/log/foo.log',
                su: true,
                su_owner: 'www-data',
                su_group: 'admin'
              }
            end

            it do
              is_expected.to contain_file('/etc/logrotate.d/test'). \
                with_content(%r{^  su www-data admin$})
            end
          end
        end

        context 'and missing su_owner' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              su: true
            }
          end

          it do
            expect do
              is_expected.to contain_file('/etc/logrotate.d/test')
            end.to raise_error(Puppet::Error, %r{su requires su_owner})
          end
        end
      end

      context 'and su => false' do
        let(:params) do
          { path: '/var/log/foo.log', su: false }
        end

        it do
          is_expected.not_to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  su\s})
        end

        context 'and su_owner => wwww-data' do
          let(:params) do
            {
              path: '/var/log/foo.log',
              su: false,
              su_owner: 'www-data'
            }
          end

          it do
            expect do
              is_expected.to contain_file('/etc/logrotate.d/test')
            end.to raise_error(Puppet::Error, %r{su_owner requires su})
          end
        end
      end

      context 'and su => foo' do
        let(:params) do
          { path: '/var/log/foo.log', su: 'foo' }
        end

        it do
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{su must be a boolean})
        end
      end

      ###########################################################################
      # UNCOMPRESSCMD
      context 'and uncompresscmd => bunzip2' do
        let(:params) do
          { path: '/var/log/foo.log', uncompresscmd: 'bunzip2' }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test'). \
            with_content(%r{^  uncompresscmd bunzip2$})
        end
      end
    end

    context 'with a non-alphanumeric title' do
      let(:title) { 'foo bar' }
      let(:params) do
        { path: '/var/log/foo.log' }
      end

      it do
        expect do
          is_expected.to contain_file('/etc/logrotate.d/foo bar')
        end.to raise_error(Puppet::Error, %r{namevar must be alphanumeric})
      end
    end

    ###########################################################################
    # CUSTOM BTMP - Make sure btmp from logrotate::defaults is not being used
    context 'with a custom btmp' do
      let(:title) { 'btmp' }
      let(:params) do
        {
          path: '/var/log/btmp',
          rotate: '10',
          rotate_every: 'day'
        }
      end
      it do
        is_expected.to contain_file('/etc/logrotate.d/btmp'). \
          with_content(%r{^/var/log/btmp \{\n  daily\n  rotate 10\n\}\n})
      end
    end

    ###########################################################################
    # CUSTOM WTMP - Make sure wtmp from logrotate::defaults is not being used
    context 'with a custom wtmp' do
      let(:title) { 'wtmp' }
      let(:params) do
        {
          path: '/var/log/wtmp',
          rotate: '10',
          rotate_every: 'day'
        }
      end
      it do
        is_expected.to contain_file('/etc/logrotate.d/wtmp'). \
          with_content(%r{^/var/log/wtmp \{\n  daily\n  rotate 10\n\}\n})
      end
    end
  end
end
