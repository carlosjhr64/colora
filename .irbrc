begin
  project = File.basename __dir__
  require project
  version = GitDiff::VERSION
  message = "### #{klass}:#{version} Ruby:#{RUBY_VERSION} ###"
rescue
  message = $!.message
end
require 'irbtools/configure'
Irbtools.welcome_message = message
Irbtools.start
