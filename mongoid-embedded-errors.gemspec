# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/embedded_errors/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-embedded-errors'
  gem.version       = Mongoid::EmbeddedErrors::VERSION.dup
  gem.authors       = ['Mark Bates', 'Kristijan Novoselić']
  gem.email         = ['mark@markbates.com', 'kristijan@glooko.com']
  gem.description   = 'Easily bubble up errors from embedded '\
                      'documents in Mongoid.'
  gem.summary       = 'Easily bubble up errors from embedded '\
                      'documents in Mongoid.'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('mongoid', '>=4.0', '<8.0.0')
  gem.add_dependency 'rubocop'
  gem.add_dependency 'rubocop-rspec'
end
