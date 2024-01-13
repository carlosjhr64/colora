module Colora
  class Error < RuntimeError; end
  VERSION = '0.1.240113'

  # Colora.run(options)
  def self.run(options=nil)
    # Standard libraries:
    require 'ostruct'
    # Gems:
    require 'fuzzystringmatch'
    require 'rainbow/refinement'
    require 'rouge'
    # Colora:
    require_relative 'colora/configure'
    require_relative 'colora/data'
    require_relative 'colora/lines'

    # Configure Colora:
    Colora.configure(options) if options
    # By default, run git-diff:
    Config.git = true if $stdin.tty? && !Config.file

    # Puts Colora::Lines
    Lines.new.each do |line|
      line.gsub!("\t", '⇥') if Config.tab
      puts line
    end
  end
end
