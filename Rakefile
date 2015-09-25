require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task(default: [:spec])
