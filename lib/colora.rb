module Colora
  class Error < RuntimeError; end
  VERSION = '0.1.240111'

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

  # Colora.run
  def self.run
    require 'colorize'
    require 'fuzzystringmatch'
    require 'rouge'
    require 'colora/themes'
    require 'colora/data'
    require 'colora/lines'
    Lines.new.each do |line|
      puts line
    end
  end
end
