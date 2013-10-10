# -*- encoding: utf-8 -*-
require File.expand_path('../lib/motion-sync-model/version', __FILE__)

Gem::Specification.new do |gem|

  gem.authors = ["Daniel Green"]
  gem.email = ["dan2552@gmail.com"]
  gem.description = "Rubymotion <-> Ruby on Rails model syncing"
  gem.summary = "Rubymotion <-> Ruby on Rails model syncing"
  gem.homepage = "https://github.com/Dan2552/motion-sync-model"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(%r{^(test|spec|lib_spec|features)/})
  gem.name          = "motion-sync-model"
  gem.require_paths = ["lib"]
  gem.version       = SyncModel::VERSION
  gem.license = 'MIT'

  gem.extra_rdoc_files = gem.files.grep(%r{motion})

  gem.add_dependency 'rake'
  gem.add_dependency 'motion-cocoapods'
  gem.add_dependency 'nano-store', '0.6.3'
  gem.add_dependency 'sugarcube', '1.1.0'
  gem.add_dependency 'bubble-wrap', '1.3.0'
  gem.add_dependency 'motion_support'
end
