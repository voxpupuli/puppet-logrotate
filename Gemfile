source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 4.2.0'
  gem "rspec", '< 3.2.0'
  gem "rspec-puppet", '>= 2.1.0'
  gem "puppetlabs_spec_helper", '>= 0.10'
  gem "metadata-json-lint"
  gem "rspec-puppet-facts"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "vagrant-wrapper"
  gem "puppet-blacksmith"
  gem "guard-rake"
end

group :system_tests do
  gem "beaker"
  gem "beaker-rspec"
end
