module Colora
  class Lines
    def markdown(line)
      txt = nil
      case line
      when /^```(\w+)$/
        txt = format(line)
        reset_lexer($~[1])
      when /^```$/
        reset_lexer
        txt = format(line)
      else
        txt = format(line)
      end
      txt
    end
  end
end
