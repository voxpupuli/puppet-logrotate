require 'spec_helper'

describe 'logrotate::conf' do
  _, facts = on_supported_os.first

  shared_examples 'error raised' do |param, _|
    context "=> 'foo'" do
      let(:params) { { param.to_sym => 'foo' } }

      it {
        expect do
          is_expected.to contain_file('/etc/logrotate.conf')
        end.to raise_error Puppet::PreformattedError
      }
    end
  end

  shared_examples 'error match' do |param, _|
    context "=> 'foo'" do
      let(:params) { { param.to_sym => 'foo' } }

      it {
        expect do
          is_expected.to contain_file('/etc/logrotate.conf')
        end.to raise_error Puppet::PreformattedError
      }
    end
  end

  shared_examples 'boolean flag' do |param, optional = true|
    it_behaves_like 'error raised', param, 'Boolean'
    context "#{param} => false" do
      let(:params) { { param.to_sym => false } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^no(t|)#{param}$})
      }
    end
    context "#{param} => true" do
      let(:params) { { param.to_sym => true } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^#{param}$})
      }
    end

    if optional
      context "#{param} missing by default" do
        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            without_content(%r{^(no(t|)|)#{param}$})
        }
      end
    end
  end

  shared_examples 'logrotate::size' do |param|
    context param do
      %w[100 100k 10M 1G].each do |value|
        context "=> #{value}" do
          let(:params) { { param.to_sym => value } }

          it {
            is_expected.to contain_file('/etc/logrotate.conf').
              with_content(%r{^#{param} #{value}$})
          }
        end
      end

      context "=> 'foo'" do
        let(:params) { { param.to_sym => 'foo' } }

        it_behaves_like 'error match', param, 'Integer or Pattern'
      end
    end
  end

  shared_examples 'integer' do |param, params = {}|
    context param do
      it_behaves_like 'error raised', param, 'Integer'
      [1, 10, 20].each do |value|
        context "#{param} => #{value}" do
          let(:params) { params.merge(param.to_sym => value) }

          it {
            is_expected.to contain_file('/etc/logrotate.conf').
              with_content(%r{^#{param} #{value}})
          }
        end
      end
    end
  end

  context '=> /etc/logrotate.conf' do
    let(:title) { '/etc/logrotate.conf' }

    context 'ensure => absent' do
      let(:params) { { ensure: 'absent' } }

      it { is_expected.to contain_file('/etc/logrotate.conf').with_ensure('absent') }
    end

    it {
      is_expected.to contain_class('logrotate')
    }
    it {
      is_expected.to contain_file('/etc/logrotate.conf').with(
        'owner' => 'root',
        'group' => 'root',
        'ensure' => 'present',
        'mode' => '0644'
      ).with_content(%r{\ninclude \/etc\/logrotate.d\n})
    }

    context 'compresscmd => bzip2' do
      let(:params) { { compresscmd: 'bzip2' } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^compresscmd bzip2$})
      }
    end

    context 'su_user => root' do
      context 'su_group => root' do
        let(:params) do
          { su_user: 'root',
            su_group: 'root' }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^su root root$})
        }
      end

      context 'su_group => undef' do
        let(:params) do
          { su_user: 'root',
            su_group: :undef }
       end
        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^su root root$})
        }
      end
    end

    context 'su_user => undef' do
      context 'su_group => root' do
        let(:params) do
          { su_user: :undef,
            su_group: 'root' }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^su root root$})
        }
      end

      context 'su_group => undef' do
        let(:params) do
          { su_user: :undef,
            su_group: :undef }
       end
        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^su root root$})
        }
      end
    end

    context 'compressext => .bz2' do
      let(:params) { { compressext: '.bz2' } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^compressext .bz2$})
      }
    end

    context 'compressoptions => -9' do
      let(:params) { { compressoptions: '-9' } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^compressoptions -9$})
      }
    end

    # CREATE / CREATE_MODE / CREATE_OWNER / CREATE_GROUP
    context 'create => true' do
      context 'create_mode => 0777' do
        let(:params) do
          { create: true,
            create_mode: '0777' }
        end

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^create 0777$})
        }

        context 'create_owner => www-data' do
          let(:params) do
            { create: true,
              create_mode: '0777',
              create_owner: 'www-data' }
          end

          it {
            is_expected.to contain_file('/etc/logrotate.conf').
              with_content(%r{^create 0777 www-data})
          }

          context 'create_group => admin' do
            let(:params) do
              { create: true,
                create_mode: '0777',
                create_owner: 'www-data',
                create_group: 'admin' }
            end

            it {
              is_expected.to contain_file('/etc/logrotate.conf').
                with_content(%r{^create 0777 www-data admin$})
            }
          end
        end

        context 'create_group => admin' do
          let(:params) do
            { create: true,
              create_mode: '0777',
              create_group: 'admin' }
          end

          it {
            expect do
              is_expected.to contain_file('/etc/logrotate.conf')
            end.to raise_error(Puppet::Error, %r{create_group requires create_owner})
          }
        end
      end

      context 'create_owner => www-data' do
        let(:params) do
          { create: true,
            create_owner: 'www-data' }
        end

        it {
          expect do
            is_expected.to contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{create_owner requires create_mode})
        }
      end
    end

    context 'create => false' do
      let(:params) { { create: false } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^nocreate$})
      }

      context 'create_mode => 0777' do
        let(:params) do
          { create: false,
            create_mode: '0777' }
        end

        it {
          expect do
            is_expected.to contain_file('/etc/logrotate.conf')
          end.to raise_error(Puppet::Error, %r{create_mode requires create})
        }
      end
    end

    context 'dateformat => -%Y%m%d' do
      let(:params) { { dateformat: '-%Y%m%d' } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').\
          with_content(%r{^dateformat -%Y%m%d$})
      }
    end

    context 'extension => foo' do
      let(:params) { { extension: '.foo' } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^extension \.foo$})
      }
    end

    # MAIL / MAILFIRST / MAILLAST
    context 'mail' do
      context '=> test.example.com' do
        let(:params) { { mail: 'test@example.com' } }

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^mail test@example.com$})
        }
        %w[mailfirst maillast].each do |value|
          context "mail_when => #{value}" do
            let(:params) do
              { mail: 'test@example.com',
                mail_when: value }
            end

            it {
              is_expected.to contain_file('/etc/logrotate.conf').
                with_content(%r{^#{value}})
            }
          end
        end
      end

      context '=> false' do
        let(:params) { { mail: false } }

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^nomail$})
        }
      end
    end

    context 'olddir' do
      context '=> /var/log/old' do
        let(:params) { { olddir: '/var/log/old' } }

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^olddir \/var\/log\/old$})
        }
      end

      context '=> false' do
        let(:params) { { olddir: false } }

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^noolddir$})
        }
      end
    end

    %w[postrotate prerotate firstaction lastaction].each do |param|
      context "#{param} => /bin/true" do
        let(:params) { { param.to_sym => '/bin/true' } }

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{#{param}\n\s{2}\/bin\/true\nendscript})
        }
      end
    end

    # ROTATE_EVERY
    context 'rotate_every =>' do
      context 'day' do
        let(:params) { { rotate_every: 'day' } }

        it {
          is_expected.to contain_file('/etc/logrotate.conf').
            with_content(%r{^daily$})
        }
      end

      %w[week month year].each do |rotate|
        context rotate do
          let(:params) { { rotate_every: rotate } }

          it {
            is_expected.to contain_file('/etc/logrotate.conf').
              with_content(%r{^#{rotate}ly})
          }
        end
      end

      context 'foo' do
        let(:params) { { rotate_every: 'foo' } }

        it_behaves_like 'error match', 'rotate_every', 'Logrotate::Every'
      end
    end

    # UNCOMPRESSCMD
    context 'uncompresscmd => bunzip2' do
      let(:params) { { uncompresscmd: 'bunzip2' } }

      it {
        is_expected.to contain_file('/etc/logrotate.conf').
          with_content(%r{^uncompresscmd bunzip2$})
      }
    end

    # Boolean Flag values
    %w[compress copy copytruncate create dateext delaycompress ifempty missingok sharedscripts shred dateyesterday].each do |param|
      it_behaves_like 'boolean flag', param, param != 'create'
    end

    # Logrotate::size
    %w[minsize size].each do |param|
      it_behaves_like 'logrotate::size', param
    end

    # Integer Values
    it_behaves_like 'integer', 'shredcycles', 'shred' => true

    %w[maxage rotate start].each do |param|
      it_behaves_like 'integer', param
    end

  end
  context '=> /etc/logrotate_custom.config' do
    let(:title) { '/etc/logrotate_custom.config' }

    it {
      is_expected.to contain_file('/etc/logrotate_custom.config').with(
        'owner' => 'root',
        'group' => 'root',
        'ensure' => 'present',
        'mode' => '0644'
      ).with_content(%r{\ninclude \/etc\/logrotate.d\n})
    }
  end
  context 'with a non-path title' do
    let(:title) { 'foo bar' }

    it_behaves_like 'error match', 'path', 'Stdlib::Unixpath'
  end
end
