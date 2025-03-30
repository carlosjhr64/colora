# frozen_string_literal: true

# Colora namespace
module Colora
  # Lines namespace
  # :reek:DuplicateMethodCall :reek:NilCheck :reek:RepeatedConditional
  class Lines
    plugins.push :diff

    # Diff plugin
    module Diff
      # :reek:TooManyStatements
      def self.flags(line)
        case line[0]
        when '-', '<'
          ldg = line.dig(1, 0)
          ['-', nil].any? { ldg == it } ? '- ' : '< '
        when '+', '>'
          ldg = line.dig(1, 0)
          ['+', nil].any? { ldg == it } ? '+ ' : '> '
        else
          '* '
        end
      end

      def self.pad(line)
        " #{line}"
      end
    end

    # category: method
    # :reek:TooManyStatements
    # rubocop:disable Metrics
    def diff(line)
      case line
      when String
        case line
        when '-', '<'
          format(line, Config.deleted)
        when '+', '>'
          format(line, Config.inserted)
        when %r{^[-+][-+][-+] ([\w./].*)$}
          reset_lang_by_filename($LAST_MATCH_INFO[1].strip.split.first)
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
        case line[0]
        when '-', '<'
          txt << format(flags, Config.deleted)
          txt << case line.dig(1, 0)
                 when '-'
                   format(code, Config.deleted)
                 else
                   format(code, Config.replaced)
                 end
          unless comment.empty?
            txt << case line.dig(2, 0)
                   when '-'
                     format(comment, Config.deleted)
                   else
                     format(comment, Config.replaced)
                   end
          end
          txt
        when '+', '>'
          txt << format(flags, Config.inserted)
          txt << case line.dig(1, 0)
                 when 'd'
                   format(code, Config.duplicated)
                 when '+'
                   format(code, Config.inserted)
                 when 'e'
                   format(code, Config.edited)
                 else # t
                   format(code, Config.touched)
                 end
          unless comment.empty?
            txt << case line.dig(2, 0)
                   when 'd'
                     format(comment, Config.duplicated)
                   when '+'
                     format(comment, Config.inserted)
                   when 'e'
                     format(comment, Config.edited)
                   else # t
                     format(comment, Config.touched)
                   end
          end
          txt
        end
      end
      # rubocop:enable Metrics
    end
  end
end
