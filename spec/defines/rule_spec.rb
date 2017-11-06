require 'spec_helper'
require 'shared_examples'

describe 'logrotate::rule' do
  _, facts = on_supported_os.first
  let(:facts) { facts }

  context 'ensure => absent' do
    let(:title) { 'test' }
    let(:params) { { ensure: 'absent' } }

    it { is_expected.to contain_file('/etc/logrotate.d/test').with_ensure('absent') }
  end

  context 'valid title' do
    let(:title) { 'test' }

    include_context 'config file', path: '/var/log/foo.log' do
      let(:config_file) { '/etc/logrotate.d/test' }
      let(:space_prefix) { '  ' }
    end

    describe 'base defaults' do
      let(:params) { { path: '/var/log/foo.log' } }

      it do
        is_expected.to contain_class('logrotate')
        is_expected.to contain_file('/etc/logrotate.d/test').with(
          'owner' => 'root',
          'group' => 'root',
          'ensure' => 'present',
          'mode' => '0644'
        ).with_content(%r{^/var/log/foo\.log \{\n\}\n})
      end
    end

    context 'with an array path' do
      let(:params) { { path: ['/var/log/foo1.log', '/var/log/foo2.log'] } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{/var/log/foo1\.log /var/log/foo2\.log \{\n\}\n})
      }
    end

    ###########################################################################
    # COMPRESSCMD
    context 'and compresscmd => bzip2' do
      let(:params) { { path: '/var/log/foo.log', compresscmd: 'bzip2' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  compresscmd bzip2$})
      }
    end

    ###########################################################################
    # COMPRESSEXT
    context 'and compressext => .bz2' do
      let(:params) { { path: '/var/log/foo.log', compressext: '.bz2' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  compressext .bz2$})
      }
    end

    ###########################################################################
    # COMPRESSOPTIONS
    context 'and compressoptions => -9' do
      let(:params) { { path: '/var/log/foo.log', compressoptions: '-9' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  compressoptions -9$})
      }
    end

    ###########################################################################
    # CREATE / CREATE_MODE / CREATE_OWNER / CREATE_GROUP
    context 'and create => true' do
      describe 'create only' do
        let(:params) { { path: '/var/log/foo.log', create: true } }

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^  create$})
        }
      end
      describe 'and create_mode => 0777' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            create: true,
            create_mode: '0777'
          }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').with_content(%r{^  create 0777$})
        }
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
          is_expected.to contain_file('/etc/logrotate.d/test').
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

          it {
            is_expected.to contain_file('/etc/logrotate.d/test').
              with_content(%r{^  create 0777 www-data admin$})
          }
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

        it {
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{create_group requires create_owner})
        }
      end

      context 'and create_owner => www-data' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            create: true,
            create_owner: 'www-data'
          }
        end

        it {
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{create_owner requires create_mode})
        }
      end
    end

    context 'and create => false' do
      let(:params) { { path: '/var/log/foo.log', create: false } }

      it do
        is_expected.to contain_file('/etc/logrotate.d/test').\
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

        it {
          expect do
            is_expected.to contain_file('/etc/logrotate.d/test')
          end.to raise_error(Puppet::Error, %r{create_mode requires create})
        }
      end
    end

    ###########################################################################
    # DATEFORMAT
    context 'and dateformat => -%Y%m%d' do
      let(:params) { { path: '/var/log/foo.log', dateformat: '-%Y%m%d' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').\
          with_content(%r{^  dateformat -%Y%m%d$})
      }
    end

    ###########################################################################
    # EXTENSION
    context 'and extension => foo' do
      let(:params) { { path: '/var/log/foo.log', extension: '.foo' } }

      it do
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  extension \.foo$})
      end
    end

    ###########################################################################
    # MAIL / MAILFIRST / MAILLAST
    context 'and mail => test.example.com' do
      let(:params) { { path: '/var/log/foo.log', mail: 'test@example.com' } }

      it do
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  mail test@example.com$})
      end

      context 'and mailfirst => true' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            mail: 'test@example.com',
            mail_when: 'mailfirst'
          }
        end

        it do
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^  mailfirst$})
        end
      end

      context 'and maillast => true' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            mail: 'test@example.com',
            mail_when: 'maillast'
          }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^  maillast$})
        }
      end
    end

    context 'and mail => false' do
      let(:params) { { path: '/var/log/foo.log', mail: false } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  nomail$})
      }
    end

    ###########################################################################
    # OLDDIR
    context 'and olddir => /var/log/old' do
      let(:params) { { path: '/var/log/foo.log', olddir: '/var/log/old' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  olddir \/var\/log\/old$})
      }
    end

    context 'and olddir => false' do
      let(:params) { { path: '/var/log/foo.log', olddir: false } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  noolddir$})
      }
    end

    ###########################################################################
    # POSTROTATE
    context 'and postrotate => /bin/true' do
      let(:params) do
        {
          path: '/var/log/foo.log',
          postrotate: '/bin/true'
        }
      end

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{postrotate\n    \/bin\/true\n  endscript})
      }
    end

    context "and postrotate => ['/bin/true', '/bin/false']" do
      let(:params) do
        {
          path: '/var/log/foo.log',
          postrotate: ['/bin/true', '/bin/false']
        }
      end

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{postrotate\n    \/bin\/true\n    \/bin\/false\n  endscript})
      }
    end

    ###########################################################################
    # PREROTATE
    context 'and prerotate => /bin/true' do
      let(:params) { { path: '/var/log/foo.log', prerotate: '/bin/true' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{prerotate\n    \/bin\/true\n  endscript})
      }
    end

    context "and prerotate => ['/bin/true', '/bin/false']" do
      let(:params) { { path: '/var/log/foo.log', prerotate: ['/bin/true', '/bin/false'] } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{prerotate\n    \/bin\/true\n    \/bin\/false\n  endscript})
      }
    end

    ###########################################################################
    # FIRSTACTION
    context 'and firstaction => /bin/true' do
      let(:params) { { path: '/var/log/foo.log', firstaction: '/bin/true' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{firstaction\n    \/bin\/true\n  endscript})
      }
    end

    context "and firstaction => ['/bin/true', '/bin/false']" do
      let(:params) { { path: '/var/log/foo.log', firstaction: ['/bin/true', '/bin/false'] } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{firstaction\n    \/bin\/true\n    \/bin\/false\n  endscript})
      }
    end

    ###########################################################################
    # LASTACTION
    context 'and lastaction => /bin/true' do
      let(:params) { { path: '/var/log/foo.log', lastaction: '/bin/true' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{lastaction\n    \/bin\/true\n  endscript})
      }
    end

    context "and lastaction => ['/bin/true', '/bin/false']" do
      let(:params) { { path: '/var/log/foo.log', lastaction: ['/bin/true', '/bin/false'] } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').\
          with_content(%r{lastaction\n    \/bin\/true\n    \/bin\/false\n  endscript})
      }
    end

    ###########################################################################
    # ROTATE
    context 'and rotate => 3' do
      let(:params) { { path: '/var/log/foo.log', rotate: 3 } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').\
          with_content(%r{^  rotate 3$})
      }
    end

    ###########################################################################
    # ROTATE_EVERY
    context 'and rotate_every => hour' do
      let(:params) { { path: '/var/log/foo.log', rotate_every: 'hour' } }

      it { is_expected.to contain_class('logrotate::hourly') }
      it { is_expected.to contain_file('/etc/logrotate.d/hourly/test') }
      it { is_expected.to contain_file('/etc/logrotate.d/test').with_ensure('absent') }
    end

    context 'and rotate_every => day' do
      let(:params) { { path: '/var/log/foo.log', rotate_every: 'day' } }

      it do
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  daily$})
      end

      it do
        is_expected.to contain_file('/etc/logrotate.d/hourly/test').
          with_ensure('absent')
      end
    end

    context 'and rotate_every => week' do
      let(:params) { { path: '/var/log/foo.log', rotate_every: 'week' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  weekly$})
      }

      it {
        is_expected.to contain_file('/etc/logrotate.d/hourly/test').
          with_ensure('absent')
      }
    end

    context 'and rotate_every => month' do
      let(:params) { { path: '/var/log/foo.log', rotate_every: 'month' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  monthly$})
      }

      it {
        is_expected.to contain_file('/etc/logrotate.d/hourly/test').
          with_ensure('absent')
      }
    end

    context 'and rotate_every => year' do
      let(:params) { { path: '/var/log/foo.log', rotate_every: 'year' } }

      it do
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  yearly$})
      end

      it do
        is_expected.to contain_file('/etc/logrotate.d/hourly/test').
          with_ensure('absent')
      end
    end

    context 'and rotate_every => foo' do
      let(:params) { { path: '/var/log/foo.log', rotate_every: 'foo' } }

      it_behaves_like 'error match', 'rotate_every', 'Logrotate::Every'
    end

    ###########################################################################
    # SHAREDSCRIPTS
    context 'and sharedscripts => true' do
      let(:params) { { path: '/var/log/foo.log', sharedscripts: true } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  sharedscripts$})
      }
    end

    context 'and sharedscripts => false' do
      let(:params) { { path: '/var/log/foo.log', sharedscripts: false } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  nosharedscripts$})
      }
    end

    ###########################################################################
    # SHRED / SHREDCYCLES
    context 'and shred => true' do
      let(:params) do
        {
          path: '/var/log/foo.log',
          shred: true
        }
      end

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  shred$})
      }

      context 'and shredcycles => 3' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            shred: true,
            shredcycles: 3
          }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^  shredcycles 3$})
        }
      end
    end

    context 'and shred => false' do
      let(:params) { { path: '/var/log/foo.log', shred: false } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  noshred$})
      }
    end

    ###########################################################################
    # START
    context 'and start => 0' do
      let(:params) do
        {
          path: '/var/log/foo.log',
          start: 0
        }
      end

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  start 0$})
      }
    end

    ###########################################################################
    # SU / SU_OWNER / SU_GROUP
    context 'and su => true' do
      # su is true and both user and group params are passed
      context 'and su_user => www-data and su_group => admin' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            su: true,
            su_user: 'www-data',
            su_group: 'admin'
          }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^  su www-data admin$})
        }
      end

      # su is true and only user param is passed
      context 'and su_user => www-data' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            su: true,
            su_user: 'www-data'
          }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^\s+su www-data root$})
        }
      end

      # su is true and only group param is passed
      context 'and su_group => admin' do
        let(:params) do
          {
            path: '/var/log/foo.log',
            su: true,
            su_group: 'admin'
          }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.d/test').
            with_content(%r{^\s+su root admin$})
        }
      end
    end

    # su is false doesn't matter if user or group params are passed
    context 'and su => false' do
      let(:params) do
        {
          path: '/var/log/foo.log',
          su: false
        }
      end

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          without_content(%r{^\s+su\s})
      }
    end

    # su param is not passed
    context 'and su => undef' do
      let(:params) do
        {
          path: '/var/log/foo.log',
          su: :undef
        }
      end

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          without_content(%r{^\s+su\s})
      }
    end

    ###########################################################################
    # UNCOMPRESSCMD
    context 'and uncompresscmd => bunzip2' do
      let(:params) { { path: '/var/log/foo.log', uncompresscmd: 'bunzip2' } }

      it {
        is_expected.to contain_file('/etc/logrotate.d/test').
          with_content(%r{^  uncompresscmd bunzip2$})
      }
    end

    %w[minsize maxsize size].each do |param|
      it_behaves_like 'logrotate::size', param
    end
    %w[compress copy copytruncate create dateext delaycompress ifempty missingok sharedscripts shred dateyesterday].each do |param|
      it_behaves_like 'boolean flag', param
    end
    %w[maxage rotate shredcycles start].each do |param|
      it_behaves_like 'error raised', param, 'Integer'
    end
  end

  context 'with a non-alphanumeric title' do
    let(:title) { 'foo bar' }
    let(:params) { { path: '/var/log/foo.log' } }

    it {
      expect do
        is_expected.to contain_file('/etc/logrotate.d/foo bar')
      end.to raise_error(Puppet::PreformattedError)
    }
  end

  ###########################################################################
  # CUSTOM BTMP - Make sure btmp from logrotate::defaults is not being used
  context 'with a custom btmp' do
    let(:title) { 'btmp' }
    let(:params) do
      {
        path: '/var/log/btmp',
        rotate: 10,
        rotate_every: 'day'
      }
    end

    it do
      is_expected.to contain_file('/etc/logrotate.d/btmp').
        with_content(%r{
/var/log/btmp {
  daily
  rotate 10
}
})
    end
  end

  ###########################################################################
  # CUSTOM WTMP - Make sure wtmp from logrotate::defaults is not being used
  context 'with a custom wtmp' do
    let(:title) { 'wtmp' }
    let(:params) do
      {
        path: '/var/log/wtmp',
        rotate: 10,
        rotate_every: 'day'
      }
    end

    it do
      is_expected.to contain_file('/etc/logrotate.d/wtmp').
        with_content(%r{
/var/log/wtmp {
  daily
  rotate 10
}
})
    end
  end

  context 'template should not inherit variables from other scopes' do
    let(:title) { 'foo' }
    let(:params) do
      {
        path: '/var/log/foo.log',
        ifempty: true
      }
    end
    let(:facts) do
      {
        osfamily: 'RedHat',
        operatingsystemmajrelease: 7
      }
    end

    it do
      is_expected.to contain_file('/etc/logrotate.d/btmp').without_content(%r{/ifempty/})
    end
  end
end
