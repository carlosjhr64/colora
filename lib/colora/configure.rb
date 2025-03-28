# frozen_string_literal: true

# Colora namespace.
# Configuration file.
module Colora
  # Filter keys:
  FILTERS = %i[quiet green red code comment dupcode dupcomment].freeze

  Struct.new('Config',
             :code, :comment, :dupcode, :dupcomment,
             :duplicated_comment, :duplicated_flag, :edited_comment,
             :edited_flag, :file, :git, :green, :inserted_comment,
             :inserted_flag, :lang, :moved_comment, :quiet, :red, :tab,
             :theme) do
    # :reek:TooManyStatements
    # rubocop:disable Metrics
    def configure(options)
      # FILE:
      self.file = options.file if options.file?

      # Options:
      self.theme = options.theme if options.theme?
      self.lang = options.lang if options.lang?
      self.git = options.git?
      self.tab = options.tab?

      FILTERS.each { self[it] = options.send("#{it}?") }
    end

    # :reek:TooManyStatements
    def reset
      FILTERS.each { self[it] = false }

      # Options:
      self.file   = nil
      self.git    = false
      self.lang   = 'ruby'
      self.theme  = 'github'
      self.tab    = false

      # Flags colors:
      self.duplicated_flag = [:default, '#E0FFFF'] # LightCyan
      self.inserted_flag   = [:default, '#ADD8E6'] # LightBlue
      self.edited_flag     = [:default, '#90EE90'] # LightGreen

      # Comments colors:
      self.moved_comment      = ['#A9A9A9', :default] # DarkGray
      self.duplicated_comment = ['#008B8B', :default] # DarkCyan
      self.inserted_comment   = ['#00008B', :default] # DarkBlue
      self.edited_comment     = ['#006400', :default] # DarkGreen
    end
    # rubocop:enable Metrics
  end

  Config = Struct::Config.new
  Config.reset # Resets to default values.
end
