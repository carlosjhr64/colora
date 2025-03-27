# frozen_string_literal: true

# Colora namespace.
# Configuration file.
module Colora
  Config = Struct.new('Config',
                      :code, :comment, :dupcode, :dupcomment,
                      :duplicated_comment, :duplicated_flag, :edited_comment,
                      :edited_flag, :file, :git, :green, :inserted_comment,
                      :inserted_flag, :lang, :moved_comment, :quiet, :red, :tab,
                      :theme).new

  # Options:
  Config.file   = nil
  Config.git    = false
  Config.lang   = 'ruby'
  Config.theme  = 'github'
  Config.tab    = false

  # Filter keys:
  FILTERS = %i[quiet green red code comment dupcode dupcomment].freeze
  FILTERS.each { Config[it] = false }

  # Flags colors:
  Config.duplicated_flag = [:default, '#E0FFFF'] # LightCyan
  Config.inserted_flag   = [:default, '#ADD8E6'] # LightBlue
  Config.edited_flag     = [:default, '#90EE90'] # LightGreen

  # Comments colors:
  Config.moved_comment      = ['#A9A9A9', :default] # DarkGray
  Config.duplicated_comment = ['#008B8B', :default] # DarkCyan
  Config.inserted_comment   = ['#00008B', :default] # DarkBlue
  Config.edited_comment     = ['#006400', :default] # DarkGreen

  # :reek:TooManyStatements
  # rubocop:disable Metrics/AbcSize
  def self.configure(options)
    # FILE:
    Config.file = options.file if options.file?

    # Options:
    Config.theme = options.theme if options.theme?
    Config.lang  = options.lang if options.lang?
    Config.git   = options.git?
    Config.tab   = options.tab?

    # Filters:
    # Config.quiet=options.quiet? ...
    FILTERS.each { Config[it] = options.send("#{it}?") }
  end
  # rubocop:enable Metrics/AbcSize
end
