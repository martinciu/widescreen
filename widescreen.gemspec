# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'widescreen/version'

Gem::Specification.new do |s|
  s.name         = "widescreen"
  s.version      = Widescreen::VERSION
  s.authors      = ["Marcin Ciunelis"]
  s.email        = "marcin.ciunelis@gmail.com"
  s.homepage     = "http://github.com/martinciu/widescreen"
  s.summary      = "[summary]"
  s.description  = "[description]"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.platform     = Gem::Platform::RUBY

  s.add_dependency 'redis',           '~> 2.2.2'
  s.add_dependency 'redis-namespace', '~> 1.0.3'
  s.add_development_dependency 'minitest', '~> 2.6.1'
  s.add_development_dependency 'timecop', '~> 0.3.5'

end
