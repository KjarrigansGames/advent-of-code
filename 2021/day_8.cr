SEGMENT ="
 aaaa
b    c
b    c
 dddd
e    f
e    f
 gggg
"

NUMS = {
  "abcdefg" => 8,
  "bcdf" => 4,   # 1 + b + d
  "acf" => 7,    # 1 + a
  "cf" => 1,     # 1

  "abcefg" => 0, # 1 + a + b + e + g
  "abcdfg" => 9, # 1 + a + b + d + g || 4 + a + g
  "abdefg" => 6, # no c || 5 + e

  "acdeg" => 2,  #
  "acdfg" => 3,  # 1 + a + d + g
  "abdfg" => 5,  # no c
}

def part1(input)
  uniq_nums = 0

  input.split("\n").map do |line|
    display, output = line.split(" | ")
    uniq_nums += output.scan(/([a-g]+)/).count { |md| [2,3,4,7].includes?(md[1].size) }
  end

  uniq_nums
end

def match?(str, ref, delta)
  (str.each_char.to_a - ref.each_char.to_a).size == delta
end

def decode_segments(combinations, output)
  eight = combinations.find { |str| str.size === 7 }
  four = combinations.find { |str| str.size === 4 }
  seven = combinations.find { |str| str.size === 3 }
  one = combinations.find { |str| str.size === 2 }
  raise "Something is weird with 8,4,7,1: #{combinations}" if one.nil? || seven.nil? || eight.nil? || four.nil?

  three = combinations.find { |str| str.size == 5 && match?(str, one, 3) }
  six = combinations.find { |str| str.size == 6 && match?(str, one, 5) }
  raise "Something is weird with 3,6: #{combinations}" if three.nil? || six.nil? || eight.nil? || four.nil?

  five = combinations.find { |str| str.size == 5 && match?(six, str, 1) }

  combinations -= [eight, four, seven, one, three, six, five]
  two = combinations.find { |str| str.size == 5 }
  nine = combinations.find { |str| str.size == 6 && match?(str, four, 2) }
  raise "Something is weird with 2,9: #{combinations} - 9->#{nine}, 2->#{two}" if nine.nil? || two.nil?

  combinations -= [two, nine]
  raise "Something is weird with zero: #{combinations}" if combinations.size > 1

  zero = combinations.first

  output.map do |digit|
    case
      when digit == zero then "0"
      when digit == one then "1"
      when digit == two then "2"
      when digit == three then "3"
      when digit == four then "4"
      when digit == five then "5"
      when digit == six then "6"
      when digit == seven then "7"
      when digit == eight then "8"
      when digit == nine then "9"
      else raise "Something is weird: #{digit}"
    end
  end.join.to_i32
end

def part2(input)
  sum = 0
  input.split("\n").map do |line|
    display, output = line.split(" | ")
    display = display.scan(/([a-g]+)/).map { |md| md[1].each_char.to_a.sort.join }
    output = output.scan(/([a-g]+)/).map { |md| md[1].each_char.to_a.sort.join }
    sum += decode_segments(display, output)
  end
  sum
end

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)

print "Part 2: "
puts part2(input)
