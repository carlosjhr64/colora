# frozen_string_literal: true

# Colora colorizes output to the terminal.
module Colora
  VERSION = '0.2.250327'

  # Colora::Error for raised exceptions in Colora.
  # Anything else is a bug.
  class Error < RuntimeError
  end

  def self.parse_argv(version, help)
    require 'help_parser'
    HelpParser[version, help]
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
