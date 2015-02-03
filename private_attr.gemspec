# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'private_attr/version'

Gem::Specification.new do |gem|
  gem.name          = "private_attr"
  gem.version       = PrivateAttr::VERSION
  gem.authors       = ["Jacob Swanner"]
  gem.email         = ["jacob@jacobswanner.com"]
  gem.description   = %q{Easily create private/protected attribute readers/writers}
  gem.summary       = %q{Easily create private/protected attribute readers/writers}
  gem.homepage      = "https://github.com/jswanner/private_attr"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'minitest', '~> 5.0'
  gem.add_development_dependency 'rake',     '~> 10.0'
end
