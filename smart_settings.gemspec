lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart_settings/version'

Gem::Specification.new do |spec|
  spec.name          = 'smart_settings'
  spec.version       = SmartSettings::VERSION
  spec.authors       = ['Jonian Guveli']
  spec.email         = ['jonian@hardpixel.eu']
  spec.summary       = %q{Persist application or record settings on ActiveRecord}
  spec.description   = %q{Stores and retrieves settings on an ActiveRecord class, with support for application and per record settings.}
  spec.homepage      = 'https://github.com/hardpixel/smart-settings'
  spec.license       = 'MIT'
  spec.files         = Dir['{lib/**/*,[A-Z]*}']
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 5.0', '< 7.0'
  spec.add_dependency 'tableless', '~> 0.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
