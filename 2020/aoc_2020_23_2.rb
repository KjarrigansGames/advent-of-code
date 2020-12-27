list = {}
input = "583976241"

# prepare input
input.each_char.each_cons(2) do |a, b|
  list[a.to_i] = b.to_i
end
list[input[-1,1].to_i] = (list.keys.max+1)
cursor = list.first.first
((list.keys.max+1)..1_000_000).each do |idx|
  list[idx] = idx + 1
end
list[1_000_000] = cursor

############## Turn

10_000_000.times do |turn|

  # pick next 3 cups
  picked = []
  picked << list[cursor]
  picked << list[picked.last]
  picked << list[picked.last]

  # calculate destination
  destination = cursor - 1
  destination = list.size if destination == 0
  while picked.include?(destination)
    destination -= 1
    destination = list.size if destination == 0
  end

  # Insert picked into the list
  old_target = list[destination]
  list[destination] = picked.first
  old_end = list[picked.last]
  list[picked.last] = old_target
  list[cursor] = old_end
  cursor = old_end
end

########################cur

print "Part 2: "
puts list[1] * list[list[1]]
