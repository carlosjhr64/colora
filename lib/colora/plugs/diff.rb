module Colora
  class Lines
    def diff(line)
      case line
      when String
        txt = nil
        case line
        when /^[-+][-+][-+] [ab]\/(.*)$/
          set_lang_by_filename($~[1])
          txt = format(line)
        when /^\s*#!/
          set_lang_by_source(line)
          txt = format(line) unless Config.quiet
        when /^ /
          txt = format(pad(line), :lang) unless Config.quiet
        else
          txt = format(line) unless Config.quiet
        end
        txt
      else
        # Initialized text variables
        txt = ''
        flags = flags(line)
        code = line.dig(1,1)||''
        comment = line.dig(2,1)||''
        # txt << flags+code
        case line[0]
        when '-', '<'
          txt << format(flags+code)
        when '+', '>'
          case line.dig(1,0)
          when nil, 't'
            txt << format(flags+code)
          when 'd'
            txt << format(flags, Config.dupplicated)
            txt << format(code, :lang)
          when '>'
            txt << format(flags, Config.inserted)
            txt << format(code, :lang)
          when 'e'
            txt << format(flags, Config.edited)
            txt << format(code, :lang)
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
            txt << format(comment, Config.deleted)
          when '+', '>'
            case line[2][0]
            when 't'
              txt << format(comment, Config.moved)
            when 'd'
              txt << format(comment, Config.dupplicated)
            when '>'
              txt << format(comment, Config.inserted)
            when 'e'
              txt << format(comment, Config.edited)
            else
              warn "Unknown comment type: #{line[0]}"
            end
          end
        end
        txt
      end
    end
  end
end
