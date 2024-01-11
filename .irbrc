#begin
#  require 'colora'
#  message = "### Colora:#{Colora::VERSION} Ruby:#{RUBY_VERSION} ###"
#rescue
#  message = $!.message
#end
require 'irbtools/configure'
#Irbtools.welcome_message = message
Irbtools.start
