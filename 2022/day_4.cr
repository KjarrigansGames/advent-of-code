TEST = [
  "2-4,6-8",
  "2-3,4-5",
  "5-7,7-9",
  "2-8,3-7",
  "6-6,4-6",
  "2-6,4-8",
]

def to_range(string)
  start, stop = string.split('-')
  (start.to_i..stop.to_i).to_a
end

def part1(input)
  duplicates = 0

  input.each do |assign|
    a, b = assign.split(',')
    a = to_range(a)
    b = to_range(b)
    a, b = b, a if a.size > b.size
    duplicates += 1 if (a - b).empty?
  end

  duplicates
end

print "Test Part 1: 2 == "
p part1(TEST)

print "Part 1: "
p part1(File.read_lines("day_4.txt"))

def part2(input)
  overlaps = 0
  input.each do |assign|
    a, b = assign.split(',')
    a = to_range(a)
    b = to_range(b)
    overlaps += 1 if (a - b).size < a.size
  end
  overlaps
end

print "Test Part 2: 4 == "
p part2(TEST)

print "Part 2: "
p part2(File.read_lines("day_4.txt"))
