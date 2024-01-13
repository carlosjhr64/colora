module Colora
  Config = OpenStruct.new

  Config.filter = ''
  Config.file   = nil
  Config.git    = false
  Config.lang   = 'ruby'
  Config.theme  = 'github'
  Config.tab    = false

  Config.inserted = [:default, :green]
  Config.deleted  = [:default, :red]
  Config.moved    = [:default, :gray]
  Config.edited   = [:default, :blue]
  Config.dup      = [:default, :magenta]

  def self.configure(options)
    # FILE:
    Config.file = options.file if options.file
    # Options:
    Config.filter << 'q' if options.quiet?
    Config.filter << '+' if options.green?
    Config.filter << '-' if options.red?
    Config.filter << 'c' if options.code?
    Config.filter << 'd' if options.dup?
    Config.filter << 'C' if options.comment?
    Config.theme = options.theme if options.theme?
    Config.lang = options.lang if options.lang?
    Config.git = options.git?
    Config.tab = options.tab?
  end
end
