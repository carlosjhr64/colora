# frozen_string_literal: true

# Colora namespace
module Colora
  # Lines namespace
  # :reek:DuplicateMethodCall :reek:NilCheck :reek:RepeatedConditional
  class Lines
    # Diff plugin
    module Diff
      def self.flags(line)
        "#{line[0]}  "
      end

      def self.pad(line)
        "  #{line}"
      end
    end

    # category: method
    # :reek:TooManyStatements
    # rubocop:disable Metrics
    def diff(line)
      case line
      when String
        case line
        when %r{^[-+][-+][-+] [ab]/(.*)$}
          reset_lang_by_filename($LAST_MATCH_INFO[1])
          format(line, :bold)
        when /^\s*#!/
          reset_lang_by_source(line)
          format(line) unless Config.quiet
        when /^ /
          format(Diff.pad(line), Config.context) unless Config.quiet
        else
          format(line) unless Config.quiet
        end
      else
        # Initialized text variables
        txt = String.new
        flags = Diff.flags(line)
        code = line.dig(1, 1) || ''
        comment = line.dig(2, 1) || ''
        # txt << flags+code
        case line[0]
        when '-', '<'
          txt << format(flags + code + comment, Config.deleted)
          comment = '' # will skip commenting below
        when '+', '>'
          txt << format(flags, Config.inserted)
          case line.dig(1, 0)
          when nil, 't'
            txt << format(code, Config.touched)
          when 'd'
            txt << format(code, Config.duplicated)
          when '>'
            txt << format(code, Config.inserted)
          when 'e'
            txt << format(code, Config.edited)
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
            txt << format(comment, Config.touched)
          when 'd'
            txt << format(comment, Config.duplicated)
          when '>'
            txt << format(comment, Config.inserted)
          when 'e'
            txt << format(comment, Config.edited)
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
