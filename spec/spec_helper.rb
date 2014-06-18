# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)

# Require simplecov before loading ..dummy/config/environment.rb because it will cause metasploit_data_models/lib to
# be loaded, which would result in Coverage not recording hits for any of the files.
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# full backtrace in logs so its easier to trace errors
Rails.backtrace_cleaner.remove_silencers!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
support_glob = Metasploit::Model.root.join('spec', 'support', '**', '*.rb')

Dir.glob(support_glob) do |path|
  require path
end

RSpec.configure do |config|
  config.before(:suite) do
    # this must be explicitly set here because it should always be spec/tmp for w/e project is using
    # Metasploit::Model::Spec to handle file system clean up.
    Metasploit::Model::Spec.temporary_pathname = Metasploit::Model.root.join('spec', 'tmp')
    # Clean up any left over files from a previously aborted suite
    Metasploit::Model::Spec.remove_temporary_pathname

    # catch missing translations
    I18n.exception_handler = Metasploit::Model::Spec::I18nExceptionHandler.new
  end

  config.after(:each) do
    Metasploit::Model::Spec.remove_temporary_pathname
  end

  config.mock_with :rspec
  config.order = :random
end
