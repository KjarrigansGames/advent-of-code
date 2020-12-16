# numbers = [0, 3, 6]

# My Input
# memory = { 0 => 1, 3 => 2, 1 => 3, 6 => 4, 7 => 5 }
# turn = 6
# num = 5

# Markus Input
# memory = {7 => 1, 12 => 2, 1 => 3, 0 => 4, 16 => 5 }
# num = 2
# turn = 6

# Raphael Input
# memory = { 2 => 1, 0 => 2, 1 => 3, 7 => 4, 4 => 5, 14 => 6, 18 => 7 }
# num = 1
# turn = 3

memory = { 1 => 1, 2 => 2, 0 => 3 }
num = 3
turn = 4

loop do
  next_num = memory.key?(num) ? (turn - memory[num]) : 0
  memory[num] = turn
  turn += 1
  num = next_num
  p num if turn == 2020
  break if turn == 30000000
end

p memory.size

p num
