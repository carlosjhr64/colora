# frozen_string_literal: true

# Colora colorizes output to the terminal.
module Colora
  VERSION = '1.0.250327'

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
    Colora.configure(options) if options # Configure Colora:
    Config.git = true if $stdin.tty? && !Config.file # By default, run git-diff
    Lines.new.each do |line|
      line.gsub!("\t", '⇥') if Config.tab
      puts line # Puts Colora::Lines
    end
  end
end
