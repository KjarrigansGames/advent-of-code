TEST = [
  "vJrwpWtwJgWrhcsFMMfFFhFp",
  "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
  "PmmdzqPrVvPwwTWBwg",
  "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
  "ttgJtRGJQctTZtZT",
  "CrZsJsPPZsGzwwsLwLmpwMDw",
]
PRIO = ('a'..'z').to_a + ('A'..'Z').to_a

def calculate_prio_score(list)
  list.map do |char|
    prio = PRIO.index(char)
    if prio.nil?
      raise "Something is wrong. Invalid char: #{char.inspect}"
    end
    prio + 1
  end.sum
end

def part1(input)
  shared_items = [] of Char

  input.each do |rucksack|
    half = (rucksack.size / 2).to_i
    comp_1 = rucksack[0, half]
    comp_2 = rucksack[half, half].each_char.to_a
    comp_1.each_char do |char|
      if comp_2.includes?(char)
        shared_items << char
        break
      end
    end
  end

  calculate_prio_score shared_items
end

print "Test Part 1: 157 == "
p part1(TEST)

print "Part 1: "
p part1(File.read_lines("day_3.txt"))

def part2(input)
  groups = [] of Char
  until input.empty?
    r1 = input.pop
    r2 = input.pop.each_char.to_a
    r3 = input.pop.each_char.to_a
    r1.each_char do |char|
      if r2.includes?(char) && r3.includes?(char)
        groups << char
        break
      end
    end
  end

  calculate_prio_score groups
end

print "Test Part 2: 70 == "
p part2(TEST)

print "Part 2: "
p part2(File.read_lines("day_3.txt"))
