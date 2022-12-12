elves = [] of Int64
current_elf = 0

input = File.read_lines("day_1.txt")
input.each do |cal|
  if cal.chomp.empty? # New Elf
    elves << current_elf
    current_elf = 0
    next
  end

  current_elf += cal.to_i64
end
elves << current_elf

print "Part 1: "
p elves.max

print "Part 2: "
p elves.sort[-3, 3].sum
