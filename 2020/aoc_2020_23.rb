DEBUG = false
list = {}
input = "583976241"

def calculate_label(list)
  label = []
  cur = 1
  until label.size == list.size - 1
    label << list[cur]
    cur = label.last
  end
  label.join
end

def debug_list(list, cursor)
  k, _ = list.first
  list.size.times do
    if k == cursor
      print '(', k, ') '
    else
      print k, ' '
    end
    k = list[k]
  end
  puts
end

# prepare input
input.each_char.each_cons(2) do |a, b|
  list[a.to_i] = b.to_i
end
list[input[-1,1].to_i] = input[0,1].to_i
cursor = list.first.first

############## Turn

100.times do |turn|
  debug_list(list, cursor) if DEBUG
#   binding.irb if turn > 4

  # pick next 3 cups
  picked = []
  picked << list[cursor]
  picked << list[picked.last]
  picked << list[picked.last]
#   binding.irb if turn > 4

  # calculate destination
  destination = cursor - 1
  destination = list.size if destination == 0
  while picked.include?(destination)
    destination -= 1
    destination = list.size if destination == 0
  end
#   binding.irb if turn > 4

  # Insert picked into the list
  old_target = list[destination]
  list[destination] = picked.first
  old_end = list[picked.last]
  list[picked.last] = old_target
  list[cursor] = old_end
  cursor = old_end
end

debug_list(list, cursor)

########################cur

print "Part 1: "
puts calculate_label(list)

binding.irb
