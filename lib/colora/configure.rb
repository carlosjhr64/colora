# frozen_string_literal: true

# Colora namespace.
# Configuration file.
module Colora
  # Filter keys:
  OPTIONS = %i[git file lang theme tab].freeze
  FILTERS = %i[quiet in out code comment dupcode dupcomment].freeze
  CODES = %i[context deleted replaced duplicated edited inserted touched].freeze

  Struct.new('Config', *OPTIONS, *CODES, *FILTERS) do
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

      # Colors:
      # rubocop:disable Style/SymbolArray
      self.context    = [:gray, :default]
      self.deleted    = [:red, :default]
      self.replaced   = [:magenta, :default]
      self.duplicated = [:cyan, :default]
      self.edited     = [:black, :default]
      self.inserted   = [:green, :default]
      self.touched    = [:blue, :default]
      # rubocop:enable Style/SymbolArray
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
        h = `git log --format='%h %s' -n 10`.lines
                                            .map { it.strip.split(' ', 2) }
        a, ma = h[a.to_i]
        puts Paint["a: #{ma}", :bold]
        if b
          b, mb = h[b.to_i]
          puts Paint["b: #{mb}", :bold]
          self.file = "#{a}..#{b}"
        else
          self.file = a
        end
      end
      true
    end
    # rubocop:enable Metrics
  end

  Config = Struct::Config.new
  Config.reset # Resets to default values.
end
