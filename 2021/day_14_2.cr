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

alias Polymer = Hash(String, Int64)
def part2(input, ticks=10)
  replacement = {} of String => String
  lines = input.split("\n")
  polymer = lines.first

  lines[2..-1].each do |rep|
    start, rep = rep.split(" -> ")
    replacement[start] = rep
  end

  poly = Polymer.new(0)
  (polymer.size-1).times do |pos|
    poly[polymer[pos, 2]] += 1
  end

  ticks.times do
    new_poly = Polymer.new(0)
    poly.each do |snip, amount|
      rep = replacement[snip]

      new_poly[snip[0]+rep] += amount
      new_poly[rep+snip[1]] += amount
    end
    poly = new_poly
  end

  ranking = Polymer.new(0)
  poly.each do |pair, amount|
    ranking[pair[0,1]] += amount
  end
  # The "last" character in each squence has to be counted as well
  pair, amount = poly.to_a.last
  ranking[pair[1,1]] += 1
  ranking = ranking.values.sort
  ranking[-1] - ranking[0]
end

input = File.read(File.expand_path(__FILE__).gsub("_2.cr", ".txt")).chomp

print "Sample 1588 == "
puts part2(SAMPLE, ticks: 10)

print "Sample 3058 == "
puts part2(input, ticks: 10)

print "Sample 2188189693529 == "
puts part2(SAMPLE, ticks: 40)

print "Part 2 (+-1): "
puts part2(input, ticks: 40)
