# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/embedded_errors/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-embedded-errors'
  gem.version       = Mongoid::EmbeddedErrors::VERSION.dup
  gem.authors       = ['Mark Bates', 'Kristijan Novoselić']
  gem.email         = ['mark@markbates.com', 'kristijan@glooko.com']
  gem.description   = 'Embedded documents in Mongoid can be really useful. '\
                      'However, when one of those embedded documents is '\
                      'invalid, Mongoid does not say which validation has '\
                      'failed. Instead of just saying that an embedded '\
                      'document is invalid, this gem modifies Mongoid '\
                      'behavior so it explicitly provides validation errors '\
                      'on a per-field basis for embedded documents, the '\
                      'same way it does for parent documents.'
  gem.summary       = 'Easily bubble up errors from embedded '\
                      'documents in Mongoid.'
  gem.homepage      = 'https://github.com/glooko/mongoid-embedded-errors'
  gem.licenses      = ['MIT']
  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('mongoid', '>=4.0', '<8.0.0')
  gem.add_development_dependency('rubocop', '~> 0.92')
  gem.add_development_dependency('rubocop-rspec', '~> 1.43')
end
