# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "better_timeout"
  gem.version       = '0.1'
  gem.authors       = ["John Joseph Bachir"]
  gem.description   = %q{Better Timeout fixes Ruby standard lib Timeout}
  gem.summary   = %q{Better Timeout fixes Ruby standard lib Timeout}
  gem.homepage      = "https://github.com/jjb/better_timeout"

  gem.files         = `git ls-files`.split($/)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
