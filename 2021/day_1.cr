SAMPLE = "199
200
208
210
200
207
240
269
260
263"

def part1(input)
  map = input.split("\n").map { |md| md.to_i32 }
  last_depth = map[0]
  increases = 0
  map[1..-1].each do |depth|
    if depth > last_depth
      increases += 1
    end
    last_depth = depth
  end

  increases
end

print "Sample 7 == "
puts part1(SAMPLE)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)

def part2(input)
  map = input.split("\n").map { |md| md.to_i32 }
  last_depth = map[0] + map[1] + map[2]
  increases = 0
  map[1..-3].each_with_index do |depth, pos|
    depth = depth + map[pos+2] + map[pos+3]
    if depth > last_depth
      increases += 1
    end
    last_depth = depth
  end

  increases
end

print "Sample 5 == "
puts part2(SAMPLE)

print "Part 2: "
puts part2(input)
