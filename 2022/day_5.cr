TEST = [
  "    [D]    ",
  "[N] [C]    ",
  "[Z] [M] [P]",
  " 1   2   3 ",
  "",
  "move 1 from 2 to 1",
  "move 3 from 1 to 3",
  "move 2 from 2 to 1",
  "move 1 from 1 to 2",
]

def pretty_stacks(list)
  puts "------------------------------"
  list.keys.sort.each do |idx|
    print idx, ": "
    list[idx].each do |crate|
      print "[#{crate}] "
    end
    puts
  end
  puts "------------------------------"
end

def do_moves(stacks, command, multi_stacks = false)
  # pretty_stacks(stacks)

  mg = command.match(/move (\d+) from (\d) to (\d)/)
  raise "Invalid commandset: #{command.inspect}" if mg.nil?

  amount = mg[1].to_i
  start_id = mg[2].to_i
  dest_id = mg[3].to_i

  if multi_stacks
    box = [] of String
    amount.times do
      box << stacks[start_id].pop
    end
    stacks[dest_id] += box.reverse
  else
    amount.times do
      stacks[dest_id] << stacks[start_id].pop
    end
  end
end

def crate_mover_900x(input, multi_stacks = false)
  stacks = Hash(Int32, Array(String)).new

  stack_mode = true
  input.each do |line|
    next if line.empty?
    if line.starts_with?(" 1")
      stack_mode = false
      stacks.each do |key, list|
        list.reverse!
      end
      next
    end

    if stack_mode
      num_stacks = ((line.size + 1) / 4).to_i
      num_stacks.times do |pos|
        crate = line[pos * 4 + 1, 1].strip
        next if crate.empty?

        if stacks[pos+1]?
          stacks[pos+1] << crate
        else
          stacks[pos+1] = [crate]
        end
      end
      next
    end

    do_moves(stacks, line, multi_stacks: multi_stacks)
  end

  stacks.keys.sort.map do |idx|
    stacks[idx].last
  end.join
end

print "Test Part 1: CMZ == "
p crate_mover_900x(TEST)

print "Part 1: "
p crate_mover_900x(File.read_lines("day_5.txt"))

print "Test Part 2: MCD == "
p crate_mover_900x(TEST, multi_stacks: true)

print "Part 2: "
p crate_mover_900x(File.read_lines("day_5.txt"), multi_stacks: true)
