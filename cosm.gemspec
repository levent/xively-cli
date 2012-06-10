$:.unshift File.expand_path("../lib", __FILE__)
require 'cosm/version'

Gem::Specification.new do |s|
  s.name = "cosm"
  s.description = "Cosm CLI"
  s.version = Cosm::VERSION

  s.authors = ["Levent Ali"]
  s.email = "lebreeze@gmail.com"
  s.license = "MIT"
  s.files = Dir.glob("{lib}/**/*") + %w(LICENSE README.md bin/cosm)
  s.homepage = "https://github.com/levent/cosm"
  s.executables = ["cosm"]
  s.require_paths = ["lib"]
  s.summary = "Provides a client to Cosm"

  s.add_dependency "cosm-rb"
end
