# frozen_string_literal: false

# Colora namespace
module Colora
  # Lines namespace
  # :reek:DuplicateMethodCall :reek:NilCheck :reek:RepeatedConditional
  class Lines
    # Diff plugin
    # :reek:TooManyStatements
    # rubocop:disable Metrics
    def diff(line)
      case line
      when String
        case line
        when %r{^[-+][-+][-+] [ab]/(.*)$}
          reset_lang_by_filename($LAST_MATCH_INFO[1])
          format(line)
        when /^\s*#!/
          reset_lang_by_source(line)
          format(line) unless Config.quiet
        when /^ /
          format(pad(line), :lang) unless Config.quiet
        else
          format(line) unless Config.quiet
        end
      else
        # Initialized text variables
        txt = ''
        flags = flags(line)
        code = line.dig(1, 1) || ''
        comment = line.dig(2, 1) || ''
        # txt << flags+code
        case line[0]
        when '-', '<'
          txt << format(flags + code + comment)
          comment = '' # will skip commenting below
        when '+', '>'
          case line.dig(1, 0)
          when nil, 't'
            txt << format(flags + code)
          when 'd'
            txt << format(flags, Config.duplicated_flag)
            txt << format(code, :lang)
          when '>'
            txt << format(flags, Config.inserted_flag)
            txt << format(code, :lang)
          when 'e'
            txt << format(flags, Config.edited_flag)
            txt << format(code, :lang)
          else
            warn "Unknown code type: #{line[0]}"
          end
        else
          warn "Unknown line type: #{line[0]}"
        end
        # txt << comment
        unless comment.empty?
          case line.dig(2, 0)
          when 't'
            txt << format(comment, Config.moved_comment)
          when 'd'
            txt << format(comment, Config.duplicated_comment)
          when '>'
            txt << format(comment, Config.inserted_comment)
          when 'e'
            txt << format(comment, Config.edited_comment)
          else
            warn "Unknown comment type: #{line[0]}"
          end
        end
        txt
      end
      # rubocop:enable Metrics
    end
  end
end
