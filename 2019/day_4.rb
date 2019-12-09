class PasswortCracker
  attr_reader :range
  def initialize(range)
    @range = range
  end

  def valid?(num)
    chars = num.to_s.chars

    return false unless chars.sort == chars

    chars.find.with_index do |char, idx|
      chars[idx + 1] == char
    end
  end

  def combinations
    @combinations ||= begin
      combi = []
      range.each do |num|
        combi << num if valid?(num)
      end
      combi
    end
  end
end

pw = PasswortCracker.new 136818..685979
p pw.combinations.size


