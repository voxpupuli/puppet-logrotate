require 'spec_helper'

describe 'logrotate::conf' do
  context 'Not a real operating system, with minimal facts set to prevent errors' do
    let(:facts) do
      {
        osfamily: 'Debian',
        operatingsystem: 'Debian',
        lsbdistrelease: 'Imaginary'
      }
    end
    context 'with an alphanumeric title' do
      let(:title) { '/etc/logrotate.conf' }

      context 'and ensure => absent' do
        let(:params) { { ensure: 'absent' } }

        it do
          should contain_file('/etc/logrotate.conf').with_ensure('absent')
        end
      end

      it do
        should contain_class('logrotate')
        should contain_file('/etc/logrotate.conf').with('owner' => 'root',
                                                        'group'   => 'root',
                                                        'ensure'  => 'present',
                                                        'mode'    => '0444').with_content(%r{\ninclude \/etc\/logrotate.d\n})
      end

      ###########################################################################
      # COMPRESS
      context 'and compress => true' do
        let(:params) do
          { compress: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^compress$})
        end
      end

      context 'and compress => false' do
        let(:params) do
          { compress: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nocompress$})
        end
      end

      context 'and compress => foo' do
        let(:params) do
          { compress: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{compress must be a boolean})
        end
      end

      ###########################################################################
      # COMPRESSCMD
      context 'and compresscmd => bzip2' do
        let(:params) do
          { compresscmd: 'bzip2' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^compresscmd bzip2$})
        end
      end

      ###########################################################################
      # COMPRESSEXT
      context 'and compressext => .bz2' do
        let(:params) do
          { compressext: '.bz2' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^compressext .bz2$})
        end
      end

      ###########################################################################
      # COMPRESSOPTIONS
      context 'and compressoptions => -9' do
        let(:params) do
          { compressoptions: '-9' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^compressoptions -9$})
        end
      end

      ###########################################################################
      # COPY
      context 'and copy => true' do
        let(:params) do
          { copy: true }
        end

        it do
          should contain_file('/etc/logrotate.conf').with_content(%r{^copy$})
        end
      end

      context 'and copy => false' do
        let(:params) do
          { copy: false }
        end

        it do
          should contain_file('/etc/logrotate.conf').with_content(%r{^nocopy$})
        end
      end

      context 'and copy => foo' do
        let(:params) do
          { copy: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{copy must be a boolean})
        end
      end

      ###########################################################################
      # COPYTRUNCATE
      context 'and copytruncate => true' do
        let(:params) do
          { copytruncate: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^copytruncate$})
        end
      end

      context 'and copytruncate => false' do
        let(:params) do
          { copytruncate: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nocopytruncate$})
        end
      end

      context 'and copytruncate => foo' do
        let(:params) do
          { copytruncate: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{copytruncate must be a boolean})
        end
      end

      ###########################################################################
      # CREATE / CREATE_MODE / CREATE_OWNER / CREATE_GROUP
      context 'and create => true' do
        let(:params) do
          { create: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^create$})
        end

        context 'and create_mode => 0777' do
          let(:params) do
            {
              create: true,
              create_mode: '0777'
            }
          end

          it do
            should contain_file('/etc/logrotate.conf'). \
              with_content(%r{^create 0777$})
          end

          context 'and create_owner => www-data' do
            let(:params) do
              {
                create: true,
                create_mode: '0777',
                create_owner: 'www-data'
              }
            end

            it do
              should contain_file('/etc/logrotate.conf'). \
                with_content(%r{^create 0777 www-data})
            end

            context 'and create_group => admin' do
              let(:params) do
                {
                  create: true,
                  create_mode: '0777',
                  create_owner: 'www-data',
                  create_group: 'admin'
                }
              end

              it do
                should contain_file('/etc/logrotate.conf'). \
                  with_content(%r{^create 0777 www-data admin$})
              end
            end
          end

          context 'and create_group => admin' do
            let(:params) do
              {
                create: true,
                create_mode: '0777',
                create_group: 'admin'
              }
            end

            it do
              expect do
                should contain_file('/etc/logrotate.conf')
              end.to raise_error(Puppet::Error, %r{create_group requires create_owner})
            end
          end
        end

        context 'and create_owner => www-data' do
          let(:params) do
            {
              create: true,
              create_owner: 'www-data'
            }
          end

          it do
            expect do
              should contain_file('/etc/logrotate.conf')
            end.to raise_error(Puppet::Error, %r{create_owner requires create_mode})
          end
        end
      end

      context 'and create => false' do
        let(:params) do
          { create: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nocreate$})
        end

        context 'and create_mode => 0777' do
          let(:params) do
            {
              create: false,
              create_mode: '0777'
            }
          end

          it do
            expect do
              should contain_file('/etc/logrotate.conf')
            end.to raise_error(Puppet::Error, %r{create_mode requires create})
          end
        end
      end

      context 'and create => foo' do
        let(:params) do
          { create: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{create must be a boolean})
        end
      end

      ###########################################################################
      # DATEEXT
      context 'and dateext => true' do
        let(:params) do
          { dateext: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^dateext$})
        end
      end

      context 'and dateext => false' do
        let(:params) do
          { dateext: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nodateext$})
        end
      end

      context 'and dateext => foo' do
        let(:params) do
          { dateext: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{dateext must be a boolean})
        end
      end

      ###########################################################################
      # DATEFORMAT
      context 'and dateformat => -%Y%m%d' do
        let(:params) do
          { dateformat: '-%Y%m%d' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^dateformat -%Y%m%d$})
        end
      end

      ###########################################################################
      # DELAYCOMPRESS
      context 'and delaycompress => true' do
        let(:params) do
          { delaycompress: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^delaycompress$})
        end
      end

      context 'and delaycompress => false' do
        let(:params) do
          { delaycompress: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nodelaycompress$})
        end
      end

      context 'and delaycompress => foo' do
        let(:params) do
          { delaycompress: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{delaycompress must be a boolean})
        end
      end

      ###########################################################################
      # EXTENSION
      context 'and extension => foo' do
        let(:params) do
          { extension: '.foo' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^extension \.foo$})
        end
      end

      ###########################################################################
      # IFEMPTY
      context 'and ifempty => true' do
        let(:params) do
          { ifempty: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^ifempty$})
        end
      end

      context 'and ifempty => false' do
        let(:params) do
          { ifempty: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^notifempty$})
        end
      end

      context 'and ifempty => foo' do
        let(:params) do
          { ifempty: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{ifempty must be a boolean})
        end
      end

      ###########################################################################
      # MAIL / MAILFIRST / MAILLAST
      context 'and mail => test.example.com' do
        let(:params) do
          { mail: 'test@example.com' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^mail test@example.com$})
        end

        context 'and mailfirst => true' do
          let(:params) do
            {
              mail: 'test@example.com',
              mailfirst: true
            }
          end

          it do
            should contain_file('/etc/logrotate.conf'). \
              with_content(%r{^mailfirst$})
          end

          context 'and maillast => true' do
            let(:params) do
              {
                mail: 'test@example.com',
                mailfirst: true,
                maillast: true
              }
            end

            it do
              expect do
                should contain_file('/etc/logrotate.conf')
              end.to raise_error(Puppet::Error, %r{set both mailfirst and maillast})
            end
          end
        end

        context 'and maillast => true' do
          let(:params) do
            {
              mail: 'test@example.com',
              maillast: true
            }
          end

          it do
            should contain_file('/etc/logrotate.conf'). \
              with_content(%r{^maillast$})
          end
        end
      end

      context 'and mail => false' do
        let(:params) do
          { mail: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nomail$})
        end
      end

      ###########################################################################
      # MAXAGE
      context 'and maxage => 3' do
        let(:params) do
          { maxage: 3 }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^maxage 3$})
        end
      end

      context 'and maxage => foo' do
        let(:params) do
          { maxage: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{maxage must be an integer})
        end
      end

      ###########################################################################
      # MINSIZE
      context 'and minsize => 100' do
        let(:params) do
          { minsize: 100 }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^minsize 100$})
        end
      end

      context 'and minsize => 100k' do
        let(:params) do
          { minsize: '100k' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^minsize 100k$})
        end
      end

      context 'and minsize => 100M' do
        let(:params) do
          { minsize: '100M' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^minsize 100M$})
        end
      end

      context 'and minsize => 100G' do
        let(:params) do
          { minsize: '100G' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^minsize 100G$})
        end
      end

      context 'and minsize => foo' do
        let(:params) do
          { minsize: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{minsize must match})
        end
      end

      ###########################################################################
      # MISSINGOK
      context 'and missingok => true' do
        let(:params) do
          { missingok: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^missingok$})
        end
      end

      context 'and missingok => false' do
        let(:params) do
          { missingok: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nomissingok$})
        end
      end

      context 'and missingok => foo' do
        let(:params) do
          { missingok: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{missingok must be a boolean})
        end
      end

      ###########################################################################
      # OLDDIR
      context 'and olddir => /var/log/old' do
        let(:params) do
          { olddir: '/var/log/old' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^olddir \/var\/log\/old$})
        end
      end

      context 'and olddir => false' do
        let(:params) do
          { olddir: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^noolddir$})
        end
      end

      ###########################################################################
      # POSTROTATE
      context 'and postrotate => /bin/true' do
        let(:params) do
          { postrotate: '/bin/true' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{postrotate\n\s{2}\/bin\/true\nendscript})
        end
      end

      ###########################################################################
      # PREROTATE
      context 'and prerotate => /bin/true' do
        let(:params) do
          { prerotate: '/bin/true' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{prerotate\n\s{2}\/bin\/true\nendscript})
        end
      end

      ###########################################################################
      # FIRSTACTION
      context 'and firstaction => /bin/true' do
        let(:params) do
          { firstaction: '/bin/true' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{firstaction\n\s{2}\/bin\/true\nendscript})
        end
      end

      ###########################################################################
      # LASTACTION
      context 'and lastaction => /bin/true' do
        let(:params) do
          { lastaction: '/bin/true' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{lastaction\n\s{2}\/bin\/true\nendscript})
        end
      end

      ###########################################################################
      # ROTATE
      context 'and rotate => 3' do
        let(:params) do
          { rotate: 3 }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^rotate 3$})
        end
      end

      context 'and rotate => foo' do
        let(:params) do
          { rotate: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{rotate must be an integer})
        end
      end

      ###########################################################################
      # ROTATE_EVERY
      context 'and rotate_every => day' do
        let(:params) do
          { rotate_every: 'day' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^daily$})
        end
      end

      context 'and rotate_every => week' do
        let(:params) do
          { rotate_every: 'week' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^weekly$})
        end
      end

      context 'and rotate_every => month' do
        let(:params) do
          { rotate_every: 'month' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^monthly$})
        end
      end

      context 'and rotate_every => year' do
        let(:params) do
          { rotate_every: 'year' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^yearly$})
        end
      end

      context 'and rotate_every => foo' do
        let(:params) do
          { rotate_every: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{invalid rotate_every value})
        end
      end

      ###########################################################################
      # SIZE
      context 'and size => 100' do
        let(:params) do
          { size: 100 }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^size 100$})
        end
      end

      context 'and size => 100k' do
        let(:params) do
          { size: '100k' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^size 100k$})
        end
      end

      context 'and size => 100M' do
        let(:params) do
          { size: '100M' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^size 100M$})
        end
      end

      context 'and size => 100G' do
        let(:params) do
          { size: '100G' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^size 100G$})
        end
      end

      context 'and size => foo' do
        let(:params) do
          { size: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{size must match})
        end
      end

      ###########################################################################
      # SHAREDSCRIPTS
      context 'and sharedscripts => true' do
        let(:params) do
          { sharedscripts: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^sharedscripts$})
        end
      end

      context 'and sharedscripts => false' do
        let(:params) do
          { sharedscripts: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^nosharedscripts$})
        end
      end

      context 'and sharedscripts => foo' do
        let(:params) do
          { sharedscripts: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{sharedscripts must be a boolean})
        end
      end

      ###########################################################################
      # SHRED / SHREDCYCLES
      context 'and shred => true' do
        let(:params) do
          { shred: true }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^shred$})
        end

        context 'and shredcycles => 3' do
          let(:params) do
            { shred: true, shredcycles: 3 }
          end

          it do
            should contain_file('/etc/logrotate.conf'). \
              with_content(%r{^shredcycles 3$})
          end
        end

        context 'and shredcycles => foo' do
          let(:params) do
            { shred: true, shredcycles: 'foo' }
          end

          it do
            expect do
              should contain_file('/etc/logrotate.conf')
            end.to raise_error(Puppet::Error, %r{shredcycles must be an integer})
          end
        end
      end

      context 'and shred => false' do
        let(:params) do
          { shred: false }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^noshred$})
        end
      end

      context 'and shred => foo' do
        let(:params) do
          { shred: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{shred must be a boolean})
        end
      end

      ###########################################################################
      # START
      context 'and start => 0' do
        let(:params) do
          { start: 0 }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^start 0$})
        end
      end

      context 'and start => foo' do
        let(:params) do
          { start: 'foo' }
        end

        it do
          expect do
            should contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{start must be an integer})
        end
      end

      ###########################################################################
      # UNCOMPRESSCMD
      context 'and uncompresscmd => bunzip2' do
        let(:params) do
          { uncompresscmd: 'bunzip2' }
        end

        it do
          should contain_file('/etc/logrotate.conf'). \
            with_content(%r{^uncompresscmd bunzip2$})
        end
      end
    end

    context 'with a non-alphanumeric title' do
      let(:title) { 'foo bar' }

      it do
        expect do
          should contain_file('/etc/logrotate.d/foo bar')
        end.to raise_error(Puppet::Error, %r{namevar must be alphanumeric})
      end
    end
  end
end
