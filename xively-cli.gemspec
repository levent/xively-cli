$:.unshift File.expand_path("../lib", __FILE__)
require 'xively-cli/version'

Gem::Specification.new do |s|
  s.name = "xively-cli"
  s.description = "Xively CLI"
  s.version = Xively::CLI::VERSION

  s.authors = ["Levent Ali"]
  s.email = "lebreeze@gmail.com"
  s.license = "MIT"
  s.files = Dir.glob("{lib}/**/*") + %w(LICENSE README.md bin/xively)
  s.homepage = "https://github.com/levent/xively-cli"
  s.executables = ["xively"]
  s.require_paths = ["lib"]
  s.summary = "Provides a client to Xively"

  s.add_dependency "xively-rb", ">= 0.2"
end
