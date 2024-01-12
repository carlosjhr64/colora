module Colora
  class Lines
    def formatter
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

    def filehandle
      Colora.git? ? IO.popen("git diff #{Colora.file}") :
      Colora.file ? File.open(Colora.file) :
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
      lexer = @lexer
      tag = lexer.tag
      pad0 = '    '; pad1 = '  '
      lang = Rouge::Lexer.find_fancy(Colora.lang)
      quiet = Colora.filter.include?('q')
      green = Colora.filter.include?('+')
      red = Colora.filter.include?('-')
      changed = Colora.filter.include?('c')
      commented = Colora.filter.include?('C')
      duplicate = Colora.filter.include?('d')
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
            when nil, 't', 'd'
              txt << @formatter.format(lexer.lex(flags+code))
            when '>'
              txt << flags.colorize(background: :light_cyan)
              txt << @formatter.format(lang.lex(code))
            when 'e'
              txt << flags.colorize(background: :light_green)
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
              txt << comment.colorize(:gray)
            when '+', '>'
              case line[2][0]
              when 't', 'd'
                txt << comment.colorize(:gray)
              when '>'
                txt << comment.colorize(:blue)
              when 'e'
                txt << comment.colorize(:green)
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
