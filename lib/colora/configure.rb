module Colora
  # Colora.filter
  def self.filter = @@filter
  def self.filter=(filter)
    @@filter=filter
  end
  Colora.filter = ''

  # Colora.file
  def self.file = @@file
  def self.file=(file)
    @@file=file
  end
  Colora.file = nil

  # Colora.git?
  def self.git? = @@git
  def self.git=(git)
    @@git = !!git
  end
  Colora.git = false

  # Colora.lang
  def self.lang = @@lang
  def self.lang=(lang)
    @@lang=lang
  end
  Colora.lang = 'ruby'

  # Colora.theme
  def self.theme = @@theme
  def self.theme=(theme)
    @@theme=theme
  end
  Colora.theme = 'github'

  # Colora.tab?
  def self.tab? = @@tab
  def self.tab=(tab)
    @@tab = !!tab
  end
  Colora.tab = false

  def self.configure(options)
    # FILE:
    Colora.file = options.file if options.file
    # Options:
    Colora.filter << 'q' if options.quiet?
    Colora.filter << '+' if options.green?
    Colora.filter << '-' if options.red?
    Colora.filter << 'c' if options.code?
    Colora.filter << 'd' if options.dup?
    Colora.filter << 'C' if options.comment?
    Colora.theme = options.theme if options.theme?
    Colora.lang = options.lang if options.lang?
    Colora.git = options.git?
    Colora.tab = options.tab?
  end
end
