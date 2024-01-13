module Colora
  class Error < RuntimeError; end
  VERSION = '0.1.240113'

  # Colora.run(options)
  def self.run(options=nil)
    require 'fuzzystringmatch'
    require 'rainbow/refinement'
    require 'rouge'
    require_relative 'colora/configure'
    require_relative 'colora/data'
    require_relative 'colora/lines'

    Colora.configure(options) if options
    # By default, run git-diff:
    Colora.git = true if $stdin.tty? && !Colora.file

    Lines.new.each do |line|
      line.gsub!("\t", '⇥') if Colora.tab?
      puts line
    end
  end
end
