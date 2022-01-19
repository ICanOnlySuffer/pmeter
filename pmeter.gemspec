# frozen_string_literal: true

require_relative 'lib/pmeter/version'

DESCRIPTION = 'Get sytem info such as CPU, RAM and SWAP usage.'
GITHUB = 'https://github.com/ICanOnlySuffer/pmeter'

Gem::Specification.new do |spec|
	spec.name        = 'pmeter'
	spec.version     = PMeter::VERSION
	spec.authors     = ["ICanOnlySuffer"]
	
	spec.summary     = DESCRIPTION
	spec.description = DESCRIPTION
	spec.homepage    = GITHUB
	spec.license     = 'MIT'
	
	spec.required_ruby_version = '>= 2.6.0'
	
	spec.metadata['homepage_uri']    = GITHUB
	spec.metadata['source_code_uri'] = GITHUB
	
	spec.files = Dir['lib/**/*', 'bin/**/*/']
	
	spec.bindir      = 'bin'
	spec.executables = []
	spec.require_paths = ["lib"]
	
	spec.post_install_message = <<~TXT
		
		Thanks a lot for downloading pmeter!
		
		Bug reports, suggestions and contributions at:
		> #{GITHUB}
		
	TXT
	
	spec.add_development_dependency 'bundler', '~> 2.0'
	spec.add_development_dependency 'rspec', '~> 3.0'
	spec.add_development_dependency 'rake', '~> 10.0'
end
