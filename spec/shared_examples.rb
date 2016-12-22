shared_context 'config file' do |base_params = {}|
  let(:space_prefix) { '' }

  shared_examples 'error raised' do |param, p_type|
    context "=> 'foo'" do
      let(:params) { {param.to_sym => 'foo'} }
      it {
        expect {
          is_expected.to contain_file(config_file)
        }.to raise_error(Puppet::Error, /'#{param}' expects a(|n) #{p_type} value/)
      }
    end
  end

  shared_examples 'error match' do |param, p_type|
    context "=> 'foo'" do
      let(:params) { {param.to_sym => 'foo'} }
      it {
        expect {
          is_expected.to contain_file(config_file)
        }.to raise_error(Puppet::PreformattedError, /'#{param}' expects a (match for|value of type) #{p_type}/)
      }
    end
  end

  shared_examples 'boolean flag' do |param, optional = true|
    it_behaves_like 'error raised', param, 'Boolean'
    context "#{param} => false" do
      let(:params) { base_params.merge({param.to_sym => false}) }
      it {
        is_expected.to contain_file(config_file).
            with_content(/^#{space_prefix}no(t|)#{param}$/)
      }
    end
    context "#{param} => true" do
      let(:params) { base_params.merge({param.to_sym => true}) }
      it {
        is_expected.to contain_file(config_file).
            with_content(/^#{space_prefix}#{param}$/)
      }
    end

    if optional
      context "#{param} missing by default" do
        let(:params) { base_params }
        it {
          is_expected.to contain_file(config_file).
              without_content(/^#{space_prefix}(no(t|)|)#{param}$/)
        }
      end
    end
  end

  shared_examples 'logrotate::size' do |param|
    context param do
      %w(100 100k 10M 1G).each do |value|
        context "=> #{value}" do
          let(:params) { base_params.merge({param.to_sym => value}) }
          it {
            is_expected.to contain_file(config_file).
                with_content(%r{^#{space_prefix}#{param} #{value}$})
          }
        end
      end

      context "=> 'foo'" do
        let(:params) { base_params.merge({param.to_sym => 'foo'}) }
        it_behaves_like 'error match', param, 'Integer or Pattern'
      end
    end
  end

  shared_examples 'integer' do |param|
    context param do
      it_behaves_like 'error raised', param, 'Integer'
      [1, 10, 20].each do |value|
        context "#{param} => #{value}" do
          let(:params) { base_params.merge({param.to_sym => value}) }
          it {
            is_expected.to contain_file(config_file).
                with_content(/^#{space_prefix}#{param} #{value}/)
          }
        end
      end
    end
  end
end