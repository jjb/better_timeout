# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "sane_timeout"
  gem.version       = '0.1'
  gem.authors       = ["John Joseph Bachir"]
  gem.email         = ["john@ganxy.com"]
  gem.description   = %q{Sane Timeout fixes Ruby standard lib Timeout}
  gem.summary   = %q{Sane Timeout fixes Ruby standard lib Timeout}
  gem.homepage      = "https://github.com/jjb/sane_timeout"

  gem.files         = `git ls-files`.split($/)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
