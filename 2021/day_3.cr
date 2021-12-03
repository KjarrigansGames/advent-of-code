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

def part2(input)
  o2 = ""
  co2 = ""

  list = input.split("\n")
  subset = list
  list.first.size.times do |pos|
    occurance = subset.map { |ele| ele[pos] }.tally
    if occurance.fetch('0', 0) <= occurance.fetch('1', 0)
      o2 += "1"
    else
      o2 += "0"
    end
    subset = subset.select do |ele|
      ele[pos] == o2[pos]
    end

    if subset.size == 1
      o2 = subset.first
      break
    end
  end

  subset = list
  list.first.size.times do |pos|
    occurance = subset.map { |ele| ele[pos] }.tally
    if occurance.fetch('0', 0) > occurance.fetch('1', 0)
      co2 += "1"
    else
      co2 += "0"
    end
    subset = subset.select do |ele|
      ele[pos] == co2[pos]
    end

    if subset.size == 1
      co2 = subset.first
      break
    end
  end

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
