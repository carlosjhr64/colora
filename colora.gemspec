Gem::Specification.new do |s|
  ## INFO ##
  s.name     = 'colora'
  s.version  = '1.0.250327'
  s.homepage = 'https://github.com/carlosjhr64/colora'
  s.author   = 'CarlosJHR64'
  s.email    = 'carlosjhr64@gmail.com'
  s.date     = '2025-03-27'
  s.licenses = ['MIT']
  ## DESCRIPTION ##
  s.summary  = <<~SUMMARY
    Colorizes terminal outputs.
  SUMMARY
  s.description = <<~DESCRIPTION
    Colorizes terminal outputs.
    
    Uses `Rouge::Formatters::Terminal256` to theme/color output to the terminal.
    Color codes git diff.
  DESCRIPTION
  ## FILES ##
  s.require_paths = ['lib']
  s.files = %w[
    README.md
    bin/colora
    lib/colora.rb
    lib/colora/configure.rb
    lib/colora/data.rb
    lib/colora/lines.rb
    lib/colora/plugs/diff.rb
    lib/colora/plugs/markdown.rb
  ]
    s.executables << 'colora'
  ## REQUIREMENTS ##
  s.add_runtime_dependency 'fuzzy-string-match', '~> 1.0', '>= 1.0.1'
  s.add_runtime_dependency 'help_parser', '~> 9.0', '>= 9.0.240926'
  s.add_runtime_dependency 'paint', '~> 2.3', '>= 2.3.0'
  s.add_runtime_dependency 'rouge', '~> 4.5', '>= 4.5.1'
end
