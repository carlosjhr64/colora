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

  # Colors:
  Config.inserted   = [:default, :green]
  Config.deleted    = [:default, :red]
  Config.moved      = [:default, :gray]
  Config.edited     = [:default, :blue]
  Config.duplicated = [:default, :magenta]

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
