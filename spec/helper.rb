if RUBY_ENGINE == 'ruby'
  require 'simplecov'
  require 'coveralls'

  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start

  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
end

require 'yaml'
require 'docker-compose/generator'
require 'rspec'

RSpec.configure do |config|
  config.raise_errors_for_deprecations!
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def fixture_read(file)
  File.read(fixture_path + '/' + file)
end
