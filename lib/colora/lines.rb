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
=begin
    def flag_color(flag)
      case flag
      when 't' # touched
        @flag == '+' ? :black : :grey
      when 'd' # duplicate
        @flag == '+' ? :magenta : :light_magenta
      else # added or removed
        if EDITS.include?(@code)
          @flag == '+' ? :green : :red
        else
          @flag == '+' ? :blue : :cyan
        end
      end
    end

    def _comment
      '#' + @line.split('#', 2)[1]
    end

    def _code
      @line[1..].split('#', 2)[0]
    end

    def _flag
      @line[0]
    end

    def do_comment
      print _comment.colorize(flag_color(COMMENT[@comment]))
    end

    def do_code_comment
      print _code.colorize(flag_color(CODE[@code]))
      do_comment if @comment
    end

    def do_flag_code_comment
      print (CODE[@code] + _flag).colorize(:gray) + ' '
      do_code_comment
    end
=end
    def each
      lexer = @lexer
      tag = lexer.tag
      pad = tag=='diff' ? '  ' : ''
      lang = Rouge::Lexer.find_fancy(Colora.lang)
      @lines.each do |line|
        case line
        when String
          if tag == 'markdown' && (md = /^```(\w*)$/.match(line.rstrip))
            if md[1].empty?
              lexer = @lexer
              yield @formatter.format(lexer.lex(line))
            else
              yield @formatter.format(lexer.lex(line))
              lexer = Rouge::Lexer.find_fancy(md[1])
             end
          else
            if tag == 'diff' && line[0] == ' '
              txt = @formatter.format(lang.lex(pad+line))
            else
              txt = @formatter.format(lexer.lex(line))
            end
            yield txt
            if (md = %r{^\+\+\+ b/(.*)$}.match(line))
              lang = Rouge::Lexer.guess_by_filename(md[1])
            elsif (md = %r{\s*#!}.match(line))
              lang = Rouge::Lexer.guess_by_source(line)
            end
          end
        else
          # TODO stuff
          flags = line[0]+line[1][0]+(line[2] ? line[2][0] : '*')
          txt = line[1][1] + (line[2] ? '#' + line[2][1] : '')
          yield @formatter.format(lexer.lex(flags))+@formatter.format(lang.lex(txt))
        end
=begin
        when /^@/
          yield line.cyan unless options.quiet?
        when /^[-+]/
          flag, code, comment = get_flag_code_comment(line)
          next if options.green? && flag == '-'
          next if options.red?   && flag == '+'
          next if options.code? && !'-+'.include?(CODE[code])
          next if options.dup? && (code.empty? || CODE[code] != 'd')

          @line = line
          @flag = flag
          @code = code
          @comment = comment
          do_flag_code_comment
          puts
        else
          puts '  ' + line.colorize(:gray) unless options.quiet?
=end
      end
    end
  end
end
