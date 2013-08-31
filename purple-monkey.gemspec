# -*- encoding: utf-8 -*-
require File.expand_path('../lib/purple-monkey/version.rb', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'purple-monkey'
  gem.version       = PurpleMonkeyMod::VERSION
  gem.licenses      = ['BSD']

  gem.authors  = ['Hwee-Boon Yar']

  gem.description = 'Barebones wrapper for working with MailChimp on iOS using RubyMotion'
  gem.summary = 'Barebones wrapper for working with MailChimp on iOS using RubyMotion'
  gem.homepage = 'https://github.com/hboon/purple-monkey'
  gem.email = 'hboon@motionobj.com'

  gem.files       = `git ls-files`.split($\)
  gem.require_paths = ['lib']
  #gem.test_files  = gem.files.grep(%r{^spec/})
end
