module Colora
  class Error < RuntimeError; end
  VERSION = '0.1.240112'

  # Colora.filter
  def self.filter = @filter
  def self.filter=(filter)
    @filter=filter
  end
  Colora.filter = ''

  # Colora.file
  def self.file = @file
  def self.file=(file)
    @file=file
  end
  Colora.file = nil

  # Colora.git?
  def self.git? = @git
  def self.git=(git)
    @git = !!git
  end
  Colora.git = false

  # Colora.lang
  def self.lang = @lang
  def self.lang=(lang)
    @lang=lang
  end
  Colora.lang = 'ruby'

  # Colora.theme
  def self.theme = @theme
  def self.theme=(theme)
    @theme=theme
  end
  Colora.theme = 'github'

  # Colora.run
  def self.run
    require 'fuzzystringmatch'
    require 'colorize'
    require 'rouge'
    require 'colora/data'
    require 'colora/lines'
    Lines.new.each do |line|
      puts line
    end
  end
end
