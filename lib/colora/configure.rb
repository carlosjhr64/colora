module Colora
  Config = OpenStruct.new

  # Options:
  Config.file   = nil
  Config.git    = false
  Config.lang   = 'ruby'
  Config.theme  = 'github'
  Config.tab    = false

  # Filters:
  Config.quiet      = false
  Config.green      = false
  Config.red        = false
  Config.code       = false
  Config.dupcode    = false
  Config.comment    = false
  Config.dupcomment = false

  # Flags colors:
  Config.duplicated_flag = [:default, '#E0FFFF'] # LightCyan
  Config.inserted_flag   = [:default, '#ADD8E6'] # LightBlue
  Config.edited_flag     = [:default, '#90EE90'] # LightGreen

  # Comments colors:
  Config.moved_comment      = ['#A9A9A9', :default] # DarkGray
  Config.duplicated_comment = ['#008B8B', :default] # DarkCyan
  Config.inserted_comment   = ['#00008B', :default] # DarkBlue
  Config.edited_comment     = ['#006400', :default] # DarkGreen

  def self.configure(options)
    # FILE:
    Config.file = options.file if options.file
    # Options:
    Config.theme = options.theme if options.theme?
    Config.lang  = options.lang if options.lang?
    Config.git   = options.git?
    Config.tab   = options.tab?
    # Filters:
    Config.quiet      = options.quiet?
    Config.green      = options.green?
    Config.red        = options.red?
    Config.code       = options.code?
    Config.comment    = options.comment?
    Config.dupcode    = options.dup?
    Config.dupcomment = options.Dup?
  end
end
