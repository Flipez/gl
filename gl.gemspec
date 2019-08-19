# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gl/version'

Gem::Specification.new do |spec|
  spec.name          = 'gl'
  spec.version       = Gl::VERSION
  spec.authors       = ['Flipez']
  spec.email         = ['code@brauser.io']

  spec.summary       = 'Environment sensible GitLab wrapper'
  spec.description   = 'Uses the GitLab API based on the git project your are currently in'
  spec.homepage      = 'https://github.com/Flipez/gl'
  spec.license       = 'AGPL-3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'gitlab', '~> 4.12'
  spec.add_dependency 'thor', '~> 0.20.3'
  spec.add_dependency 'tty-progressbar', '~> 0.17.0'
  spec.add_dependency 'tty-prompt', '~> 0.19.0'
  spec.add_dependency 'tty-spinner', '~> 0.9.1'
  spec.add_dependency 'tty-table', '~> 0.11.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
end
