require "rubygems"
require "rubygems/package_task"
require "rake/clean"
require "rspec/core/rake_task"

CLEAN.include('.DS_Store')
CLOBBER.include('pkg')
CLOBBER.include('coverage')
CLOBBER.include('doc')

Bundler::GemHelper.install_tasks

PROJECT_ROOT = File.expand_path("..", __FILE__)
$:.unshift "#{PROJECT_ROOT}/lib"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--format documentation --colour)
  t.verbose = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
