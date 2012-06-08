$:.unshift File.expand_path("../lib", __FILE__)
require 'cosm/version'

Gem::Specification.new do |s|
  s.name = "cosm"
  s.version = Cosm::VERSION

  s.authors = ["Levent Ali"]
  s.email = "lebreeze@gmail.com"
  s.executables = ["cosm"]
  s.license = "MIT"
  s.files = Dir.glob("{lib}/**/*") + %w(LICENSE README.md)
  s.homepage = "https://cosm.com"
  s.require_paths = ["lib"]
  s.summary = "What this thing does"
end
