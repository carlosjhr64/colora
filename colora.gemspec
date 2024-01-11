Gem::Specification.new do |s|
  ## INFO ##
  s.name     = 'colora'
  s.version  = '0.1.240111'
  s.homepage = 'https://github.com/carlosjhr64/colora'
  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'
  s.date     = '2024-01-11'
  s.licenses = ['MIT']
  ## DESCRIPTION ##
  s.summary  = <<~SUMMARY
    TODO: short summary
  SUMMARY
  s.description = <<~DESCRIPTION
    TODO: short summary
    
    TODO: more...
  DESCRIPTION
  ## FILES ##
  s.require_paths = ['lib']
  s.files = %w[
    README.md
    bin/colora
    lib/colora.rb
  ]
    s.executables << 'colora'
  ## REQUIREMENTS ##
  s.add_runtime_dependency 'colorize', '~> 1.1', '>= 1.1.0'
  s.add_runtime_dependency 'fuzzy-string-match', '~> 1.0', '>= 1.0.1'
  s.add_runtime_dependency 'help_parser', '~> 8.2', '>= 8.2.230210'
  s.add_runtime_dependency 'rouge', '~> 4.2', '>= 4.2.0'
  s.add_development_dependency 'cucumber', '~> 9.1', '>= 9.1.0'
  s.add_development_dependency 'parser', '~> 3.2', '>= 3.2.2'
  s.add_development_dependency 'rubocop', '~> 1.59', '>= 1.59.0'
  s.add_development_dependency 'test-unit', '~> 3.6', '>= 3.6.1'
  s.requirements << 'git: 2.30'
end
