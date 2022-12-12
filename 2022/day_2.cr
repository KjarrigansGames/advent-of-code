# A / X = Rock
# B / Y = Paper
# C / Z = Scissors
# Win / Draw / Lost =  6 / 3 / 0
OUTCOME_PART1 = {
  "A X" => 1+3,
  "A Y" => 2+6,
  "A Z" => 3+0,
  "B X" => 1+0,
  "B Y" => 2+3,
  "B Z" => 3+6,
  "C X" => 1+6,
  "C Y" => 2+0,
  "C Z" => 3+3,
}
def score(input, outcome)
  sum = 0
  input.each do |instruction|
    sum += outcome[instruction.chomp]
  end
  p sum
end
print "Test Part 1: 15 == "
score(["A Y", "B X", "C Z"], OUTCOME_PART1)

print "Part 1: "
score(File.read_lines("day_2.txt"), OUTCOME_PART1)

# A / B / C remains as in Part 1
# X / Y / Z = Lost / Draw / Win
OUTCOME_PART2 = {
  "A X" => 0+3,
  "A Y" => 3+1,
  "A Z" => 6+2,
  "B X" => 0+1,
  "B Y" => 3+2,
  "B Z" => 6+3,
  "C X" => 0+2,
  "C Y" => 3+3,
  "C Z" => 6+1,
}

print "Test Part 2: 12 == "
score(["A Y", "B X", "C Z"], OUTCOME_PART2)

print "Part 2: "
score(File.read_lines("day_2.txt"), OUTCOME_PART2)

