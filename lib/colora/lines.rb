module Colora
  class Lines
    def formatter
      theme = Rouge::Theme.find(Config.theme)
      raise Error, "Unrecognized theme: #{Config.theme}" unless theme
      Rouge::Formatters::Terminal256.new(theme.new)
    end

    def get_lexer_by_file(file = Config.file)
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

    def filehandle
      Config.git ? IO.popen("git diff #{Config.file}") :
      Config.file ? File.open(Config.file) :
                    $stdin
    end

    def get_lines(fh = filehandle)
      fh.readlines.map(&:chomp)
    end

    def initialize
      @formatter = formatter
      lines = get_lines
      @lexer = get_lexer_by_file || get_lexer_by_source(lines[0])
      @lines = Data.new(lines).lines
    end

    def to_a = @lines

    def each
      commented = Config.filter.include?('C')
      duplicate = Config.filter.include?('d')
      changed   = Config.filter.include?('c')
      quiet     = Config.filter.include?('q')
      green     = Config.filter.include?('+')
      lang      = Rouge::Lexer.find_fancy(Config.lang)
      red       = Config.filter.include?('-')
      pad0      = '    '; pad1 = '  '
      lexer     = @lexer
      tag       = lexer.tag
      @lines.each do |line|
        case line
        when String
          case tag
          when 'diff'
            case line
            when /^[-+][-+][-+] [ab]\/(.*)$/
              lang = Rouge::Lexer.guess_by_filename($~[1])
              unless (green && line[0]=='-') || (red && line[0]=='+')
                yield @formatter.format(lexer.lex(line))
              end
            when /^\s*#!/
              lang = Rouge::Lexer.guess_by_source(line)
              yield @formatter.format(lexer.lex(line)) unless quiet
            when /^ /
              yield @formatter.format(lang.lex(pad0+line)) unless quiet
            else
              yield @formatter.format(lexer.lex(line)) unless quiet
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
          # Filters
          next if duplicate && line.dig(1,0)=='d'
          next if commented && [nil, 't'].include?(line.dig 2,0)
          next if changed   && [nil,'t'].include?(line.dig 1,0)
          next if green     && '-<'.include?(line[0])
          next if red       && '+>'.include?(line[0])
          # Initialized text variables
          txt = ''
          flags = line[0] + (line.dig(1,0)||'*') + (line.dig(2,0)||'*') + pad1
          code = line.dig(1,1)||''
          comment = line.dig(2,1)||''
          # txt << flags+code
          case line[0]
          when '-', '<'
            txt << @formatter.format(lexer.lex(flags+code))
          when '+', '>'
            case line.dig(1,0)
            when nil, 't'
              txt << @formatter.format(lexer.lex(flags+code))
            when 'd'
              txt << Paint[flags, *Config.dup]
              txt << @formatter.format(lang.lex(code))
            when '>'
              txt << Paint[flags, *Config.inserted]
              txt << @formatter.format(lang.lex(code))
            when 'e'
              txt << Paint[flags, *Config.edited]
              txt << @formatter.format(lang.lex(code))
            else
              warn "Unknown code type: #{line[0]}"
            end
          else
            warn "Unknown line type: #{line[0]}"
          end
          # txt << comment
          unless comment.empty?
            case line[0]
            when '-', '<'
              txt << Paint[comment, *Config.deleted]
            when '+', '>'
              case line[2][0]
              when 't'
                txt << Paint[comment, *Config.moved]
              when 'd'
                txt << Paint[comment, *Config.dup]
              when '>'
                txt << Paint[comment, *Config.inserted]
              when 'e'
                txt << Paint[comment, *Config.edited]
              else
                warn "Unknown comment type: #{line[0]}"
              end
            end
          end
          yield txt
        end
      end
    end
  end
end
