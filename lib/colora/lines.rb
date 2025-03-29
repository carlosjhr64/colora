# frozen_string_literal: true

# Colora namespace
module Colora
  # Here we read lines and color each to be yielded out.
  # rubocop:disable Metrics/ClassLength
  class Lines
    def filehandle
      if Config.git
        IO.popen("git diff #{Config.file}")
      elsif Config.file
        File.open(Config.file)
      else
        $stdin
      end
    end

    def get_lines(getter = filehandle)
      getter.readlines.map(&:chomp)
    ensure
      getter.close
    end

    def formatter
      theme = Rouge::Theme.find(Config.theme)
      raise Error, "Unrecognized theme: #{Config.theme}" unless theme

      Rouge::Formatters::Terminal256.new(theme.new)
    end

    def initialize
      @formatter = formatter
      @lines = get_lines
      @lexer = @orig_lexer = guess_lexer
      @tag   = @lexer.tag
      @lines = @tag == 'diff' ? Data.new(@lines).lines : @lines
      @lang  = @orig_lang = Rouge::Lexer.find_fancy(Config.lang)
      # `@on` is `true` unless there is a `Config.on` condition to be met
      @on = Config.on ? false : true
    end

    def guess_lexer
      return Rouge::Lexers::Diff if Config.git

      guess_lexer_by_file || guess_lexer_by_source
    end

    def guess_lexer_by_file(file = Config.file)
      return nil unless file && !File.extname(file).empty?

      Rouge::Lexer.guess_by_filename(file)
    end

    def guess_lexer_by_source(source = @lines[0])
      case source
      when /^---( #.*)?$/, /^# /
        Rouge::Lexers::Markdown
      when %r{^--- [\w./]}
        Rouge::Lexers::Diff
      else
        Rouge::Lexer.guess_by_source(source)
      end
    end

    def toggle(line)
      if @on
        @on = false if Config.off&.match?(line)
      elsif Config.on&.match?(line)
        @on = true
      end
    end

    # rubocop:disable Metrics
    def by_filters?(line)
      (Config.in && '-<'.include?(line[0])) ||
        (Config.out && '+>'.include?(line[0])) ||
        (Config.code && [nil, 't'].include?(line.dig(1, 0))) ||
        (Config.comment && [nil, 't'].include?(line.dig(2, 0))) ||
        (Config.dupcode && line.dig(1, 0) == 'd') ||
        (Config.dupcomment && line.dig(2, 0) == 'd') ||
        false
    end
    # rubocop:enable Metrics

    def filtered?(line, str = line.is_a?(String))
      toggle(line) if str
      return true unless @on
      return false if str

      by_filters?(line)
    end

    def txt_formatter(line)
      # Is there a plugin for @tag? If so, use it: Else use the lexer.
      if respond_to?(@tag)
        send(@tag, line)
      else
        @formatter.format(@lexer.lex(line))
      end
    end

    def each
      @lines.each do |line|
        next if filtered?(line)

        txt = txt_formatter(line)
        yield txt if txt
      end
      reset_lexer
      reset_lang
    end

    def reset_lexer(lang = nil)
      @lexer = if lang.nil?
                 @orig_lexer
               else
                 Rouge::Lexer.find_fancy(lang) || @orig_lexer
               end
    end

    def reset_lang(lang = nil)
      @lang  = if lang.nil?
                 @orig_lang
               else
                 Rouge::Lexer.find_fancy(lang) || @orig_lang
               end
    end

    def format(line, color = nil)
      case color
      when nil
        @formatter.format(@lexer.lex(line))
      when :lang
        @formatter.format(@lang.lex(line))
      else
        Paint[line, *color]
      end
    end

    def reset_lang_by_filename(file)
      @lang = Rouge::Lexer.guess_by_filename(file)
    end

    def reset_lang_by_source(source)
      @lang = Rouge::Lexer.guess_by_source(source)
    end

    def to_a = @lines
  end
  # rubocop:enable Metrics/ClassLength
end
