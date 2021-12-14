SAMPLE ="NNCB

CH -> B
HH -> N
CB -> H
NH -> C
HB -> C
HC -> B
HN -> C
NN -> C
BH -> H
NC -> B
NB -> B
BN -> B
BB -> N
BC -> B
CC -> N
CN -> C"

def part1(input, ticks=10)
  replacement = {} of String => String
  lines = input.split("\n")
  polymer = lines.first
  lines[2..-1].each do |rep|
    start, rep = rep.split(" -> ")
    replacement[start] = start[0] + rep
  end

  ticks.times do |tick|
    new_poly = ""
    (polymer.size - 1).times do |cursor|
      new_poly += replacement[polymer[cursor, 2]]
    end
    polymer = new_poly + polymer[-1]
  end
  ranking = polymer.each_char.to_a.tally.values.sort
  ranking[-1] - ranking[0]
end

print "Sample 1 == "
puts part1(SAMPLE, ticks: 1)

print "Sample 1588 == "
puts part1(SAMPLE, ticks: 10)
#
input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)
