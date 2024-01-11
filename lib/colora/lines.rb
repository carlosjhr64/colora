module Colora
  class Lines
    def get_formatter
      theme = Rouge::Theme.find(Colora.theme)
      Rouge::Formatters::Terminal256.new(theme.new)
    end

    def get_lexer_by_file(file = Colora.file)
      return nil unless file && !File.extname(file).empty?
      Rouge::Lexer.guess_by_filename(file)
    end

    def get_lexer_by_source(source)
      case source
      when /^---/, /^# /
        Rouge::Lexer.guess_by_filename('*.md')
      else
        Rouge::Lexer.guess_by_source(source)
      end
    end

    def get_fh
      Colora.git? ? IO.popen("git diff #{Colora.file}") :
      Colora.file ? File.open(Colora.file) :
                    $stdin
    end

    def get_lines(fh = get_fh)
      lines = fh.readlines.map(&:chomp)
      lines
    end

    def initialize
      @formatter = get_formatter
      lines = get_lines
      @lexer = get_lexer_by_file || get_lexer_by_source(lines[0])
      @lines = Data.new(lines).lines
    end


    def to_a = @lines

    def each
      lexer = @lexer
      tag = lexer.tag
      pad = tag=='diff' ? '  ' : ''
      lang = Rouge::Lexer.find_fancy(Colora.lang)
      @lines.each do |line|
        case line
        when String
          case tag
          when 'diff'
            unless Colora.filter.include?('q') # quiet
              case line[0]
              when ' '
                yield @formatter.format(lang.lex(pad+line))
              else
                yield @formatter.format(lang.lex(line))
              end
            end
            case line
            when /^\+\+\+ b\/(.*)$/
              lang = Rouge::Lexer.guess_by_filename($~[1])
            when /^\s*#!/
              lang = Rouge::Lexer.guess_by_source(line)
            end
          when 'markdown'
            case line
            when /^```(\w+)$/
              yield @formatter.format(lexer.lex(line))
              lexer = Rouge::Lexer.find_fancy($~[1])
            when /^```$/
              lexer = @lexer
              yield @formatter.format(lexer.lex(line))
            else
              yield @formatter.format(lexer.lex(line))
            end
          else
            yield @formatter.format(lexer.lex(line))
          end
        else
          next if '-<'.include?(line[0]) && Colora.filter.include?('-')
          next if '+>'.include?(line[0]) && Colora.filter.include?('+')
          next if line[1][0] == 't' && Colora.filter.include?('t')
          next if Colora.filter.include?('d') && !line[1][0]=='d'
          flags = line[0]+line[1][0]+(line[2] ? line[2][0] : '*')
          txt = @formatter.format(lexer.lex(flags))
          code = line[1][1]
          case line[1][0]
          when 'd'
            txt << code.colorize(:cyan)
          when 't'
            txt << @formatter.format(lang.lex(code))
          when 'e'
            txt << ('+>'.include?(line[0])? code.colorize(:green) : code.colorize(:red))
          when '>'
            txt << code.colorize(:blue)
          when '<'
            txt << code.colorize(:magenta)
          end
          if line[2] # Optional comment
            comment = '#'+line[2][1]
            case line[2][0]
            when 'd'
              txt << comment.colorize(:cyan)
            when 't'
              txt << @formatter.format(lang.lex(comment))
            when 'e'
              txt << ('+>'.include?(line[0])? comment.colorize(:green) : comment.colorize(:red))
            when '>'
              txt << comment.colorize(:blue)
            when '<'
              txt << comment.colorize(:magenta)
            end
          end
          yield txt
        end
      end
    end
  end
end
