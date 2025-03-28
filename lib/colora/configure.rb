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
    # rubocop:disable Metrics
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

    # :reek:TooManyStatements
    def configure(options)
      # FILE:
      self.file = options.file if options.file?

      # Options:
      self.theme = options.theme if options.theme?
      self.lang = options.lang if options.lang?
      self.git = options.git?
      self.tab = options.tab?

      FILTERS.each { self[it] = options.send("#{it}?") }

      file_check
    end

    private

    # :reek:UncommunicativeVariableName
    def efd
      e = File.exist?(file)
      f = e && File.file?(file)
      d = e && !f && File.directory?(file)
      [e, f, d]
    end

    # :reek:UncommunicativeVariableName :reek:TooManyStatements
    def file_check
      return unless file

      e, f, d = efd
      raise Colora::Error, "Not a file or directory: #{file}" if e && !(f || d)
      return if f # It's a file.

      if git
        return if d # It's a diff on directory.
        return if gitlog
      end
      raise Colora::Error, "Does not exist: #{file}" unless e
      raise Colora::Error, "Is a directory: #{file}" if d

      raise "Unexpected error: #{file}" # Should not happen.
    end

    # :reek:UncommunicativeVariableName :reek:NilCheck :reek:TooManyStatements
    def gitlog
      return false unless (mdt = /^(\h+)(\.\.(\h+))?$/.match(file))

      a, b = mdt.values_at(1, 3)
      if a != b && /^\d$/.match?(a) && (b.nil? || /^\d$/.match?(b))
        h = `git log --format='%h' -n 10`.lines.map(&:chomp)
        str = h[a.to_i]
        str << "..#{h[b.to_i]}" if b
        self.file = str
      end
      true
    end
    # rubocop:enable Metrics
  end

  Config = Struct::Config.new
  Config.reset # Resets to default values.
end
