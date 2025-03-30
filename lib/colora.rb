# frozen_string_literal: true

# Colora colorizes output to the terminal.
module Colora
  VERSION = '1.0.250330'

  # Colora::Error for raised exceptions in Colora.
  # Anything else is a bug.
  class Error < RuntimeError
  end

  def self.parse_argv(help)
    require 'help_parser'
    HelpParser[VERSION, help]
  end

  # Colora.run(options)
  # :reek:TooManyStatements
  def self.run(options = nil)
    require_relative 'colora/requires'
    Config.configure(options) if options # Configure Colora:
    # If stdin is a tty(we're not in a pipe) and no file is specified,
    # then default to running git-diff.
    Config.git = true if $stdin.tty? && !Config.file
    Lines.new.each do |line|
      line.gsub!("\t", '⇥') if Config.tab
      puts line # Puts Colora::Lines
    end
  end
end
