SAMPLE = "00100
11110
10110
10111
10101
01111
00111
11100
10000
11001
00010
01010"

def part1(input)
  gamma = ""
  epsilon = ""
  list = input.split("\n")

  list.first.size.times do |pos|
    occurance = list.map { |ele| ele[pos] }.tally
    if occurance.fetch('0', 0) > occurance.fetch('1', 0)
      gamma += "0"
      epsilon += "1"
    else
      gamma += "1"
      epsilon += "0"
    end
  end

  gamma.to_i32(2) * epsilon.to_i32(2)
end

def scan_for(subset, msb = '1', lsb = '0')
  subset.first.size.times do |pos|
    occurance = subset.map { |ele| ele[pos] }.tally
    subset = subset.select do |ele|
      ele[pos] == (occurance.fetch('0', 0) <= occurance.fetch('1', 0) ? msb : lsb)
    end

    return subset.first if subset.size == 1
  end
end

def part2(input)
  list = input.split("\n")
  o2 = scan_for(list, '1', '0') || '0'
  co2 = scan_for(list, '0', '1') || '0'

  o2.to_i32(2) * co2.to_i32(2)
end

print "Sample 198 == "
puts part1(SAMPLE.chomp)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)

print "Sample 230 == "
puts part2(SAMPLE.chomp)

print "Part 2: "
puts part2(input)
