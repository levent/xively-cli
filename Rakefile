require "rubygems"
require "rubygems/package_task"

PROJECT_ROOT = File.expand_path("..", __FILE__)
$:.unshift "#{PROJECT_ROOT}/lib"

require "cosm/version"
require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--format documentation --colour)
  t.verbose = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
