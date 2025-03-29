# frozen_string_literal: true

# Colora namespace
module Colora
  # Lines namespace
  # :reek:DuplicateMethodCall
  class Lines
    plugins.push :markdown

    # Markdown plug
    # :reek:TooManyStatements
    # rubocop:disable Metrics
    def markdown(line)
      txt = nil
      case line
      when /^```(\w+)$/
        txt = format(line)
        reset_lexer($LAST_MATCH_INFO[1])
      when /^```$/
        reset_lexer
        txt = format(line)
      else
        txt = format(line)
      end
      txt
    end
    # rubocop:enable Metrics
  end
end
