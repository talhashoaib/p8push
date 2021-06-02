# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'p8push/version'

Gem::Specification.new do |s|
  s.name        = 'ts_p8push'
  s.authors     = ['Andrew Arrow','Mattt Thompson', 'Kim Laplume', 'Talha Shoaib']
  s.email       = 'talhashoaib27@gmail.com'
  s.license     = 'MIT'
  s.homepage    = 'https://talhashoaib.me'
  s.version     = P8push::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Send Apple Push Notifications'
  s.description = 'apple push notifications using only the new p8 format not the older pem format. fork from 1klap/p8push'

  s.add_dependency 'jwt', '1.5.6'
  s.add_dependency 'commander', '4.4'
  s.add_dependency 'json', '2.1.0'
  s.add_dependency 'net-http2', '0.18.2'

  s.files         = Dir['./**/*'].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
