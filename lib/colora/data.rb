# frozen_string_literal: true

# Colora namespace.
module Colora
  # Data class for processing git-diff lines.
  # :reek:DuplicateMethodCall :reek:UncommunicativeVariableName
  # :reek:TooManyStatements
  class Data
    # :reek:NilCheck
    def self.update(hash, key, flag)
      k = key.strip
      hash[k] = case hash[k]
                when nil
                  flag # added(+>) or removed(-<)
                when 'd', 't', flag
                  'd' # duplicate
                else
                  't' # touched
                end
    end

    def self.reflag(flag)
      if flag == '-'
        '<'
      else
        flag == '+' ? '>' : flag
      end
    end

    def self.split(line)
      flag = line[0]
      code, pounds, comment = line[1..].split(/(?<!['"])(\s*#+)(?!{)/, 2)
      code = nil if code.empty?
      comment ? [flag, code, pounds + comment] : [flag, code, nil]
    end

    attr_reader :lines

    def initialize(lines)
      @lines = []
      @codes = {}
      @comments = {}
      @edits = Set.new
      populate_lines(lines)
      populate_edits
      @lines.each do |line|
        next unless line.is_a?(Array)

        post_process line
      end
    end

    private

    def flag_code_comment(line)
      flag, code, comment = Data.split(line)
      f = Data.reflag(flag)
      Data.update(@codes, code, f) if code
      Data.update(@comments, comment, f) if comment
      [flag, code, comment]
    end

    def populate_lines(lines)
      while (line = lines.shift)
        @lines << pre_process(line)
      end
    end

    # :reek:FeatureEnvy
    def post_process(line)
      if (code = line[1]&.strip)
        flag = @edits.include?(code) ? 'e' : @codes[code]
        line[1] = [flag, line[1]]
      end
      if (comment = line[2]&.strip)
        flag = @comments[comment]
        line[2] = [flag, line[2]]
      end
    end

    def pre_process(line)
      # rubocop:disable Lint/DuplicateBranch
      case line.rstrip
      when '', '+', '-', '---', /^[-+][-+][-+] [ab]/
        line
      when /^[-+<>]/
        flag_code_comment(line)
      else
        line
      end
      # rubocop:enable Lint/DuplicateBranch
    end

    def populate_edits
      partners.sort_by(&:last).reverse.each do |a, b, _|
        next if @edits.include?(a) || @edits.include?(b)

        @edits.add(a)
        @edits.add(b)
      end
    end

    # :reek:NestedIterators
    def partners
      partners = []
      short, long, jarrow = short_long_jarrow
      short.each do |a|
        long.each do |b|
          d = jarrow.getDistance(a, b)
          partners.push([a, b, d]) if d > 0.618034
        end
      end
      partners
    end

    def short_long_jarrow
      jarrow = FuzzyStringMatch::JaroWinkler.create(:pure) # Need pure for UTF-8
      removed = @codes.select { |_, flag| '-<'.include? flag }.keys
      added   = @codes.select { |_, flag| '+>'.include? flag }.keys
      short, long = [removed, added].sort_by(&:length)
      [short, long, jarrow]
    end
  end
end
