class Device
  property cycle = 0
  property register_x = 1
  property signal_strength = 0
  property crt = [] of Char
  
  def reset
    @cycle = 0
    @register_x = 1
    @signal_strength = 0
  end

  def increment_cycle
    @cycle += 1
    @signal_strength += (register_x * @cycle) if (@cycle - 20) % 40 == 0
  end

  def part1(input)
    reset 
    
    input.each do |command|
      case command
      when "noop" then increment_cycle
      when /addx (-?\d+)/
        increment_cycle
        increment_cycle
        @register_x += $1.to_i
      else
        raise "Invalid command: #{command.inspect}"
      end
      
      break if @cycle == 220
    end
    
    signal_strength
  end
  
  def draw_crt
    row_pos = @cycle % 40
    
    # register_x = position of center pixel in 3 pixel sprite 
    if [register_x-1, register_x, register_x+1].includes?(row_pos)
      @crt << '#'
    else
      @crt << '.'
    end
    
    @cycle += 1
  end
  
  def part2(input)
    reset 
    
    input.each do |command|
      case command
      when "noop" then draw_crt
      when /addx (-?\d+)/
        draw_crt
        draw_crt
        @register_x += $1.to_i
      else
        raise "Invalid command: #{command.inspect}"
      end
      
      break if @cycle == 240
    end
    
    @crt.each_with_index do |pixel, pos|
      puts if pos % 40 == 0
      print pixel
    end
    puts
  end
end

TEST = [
  "addx 15",
  "addx -11",
  "addx 6",
  "addx -3",
  "addx 5",
  "addx -1",
  "addx -8",
  "addx 13",
  "addx 4",
  "noop",
  "addx -1",
  "addx 5",
  "addx -1",
  "addx 5",
  "addx -1",
  "addx 5",
  "addx -1",
  "addx 5",
  "addx -1",
  "addx -35",
  "addx 1",
  "addx 24",
  "addx -19",
  "addx 1",
  "addx 16",
  "addx -11",
  "noop",
  "noop",
  "addx 21",
  "addx -15",
  "noop",
  "noop",
  "addx -3",
  "addx 9",
  "addx 1",
  "addx -3",
  "addx 8",
  "addx 1",
  "addx 5",
  "noop",
  "noop",
  "noop",
  "noop",
  "noop",
  "addx -36",
  "noop",
  "addx 1",
  "addx 7",
  "noop",
  "noop",
  "noop",
  "addx 2",
  "addx 6",
  "noop",
  "noop",
  "noop",
  "noop",
  "noop",
  "addx 1",
  "noop",
  "noop",
  "addx 7",
  "addx 1",
  "noop",
  "addx -13",
  "addx 13",
  "addx 7",
  "noop",
  "addx 1",
  "addx -33",
  "noop",
  "noop",
  "noop",
  "addx 2",
  "noop",
  "noop",
  "noop",
  "addx 8",
  "noop",
  "addx -1",
  "addx 2",
  "addx 1",
  "noop",
  "addx 17",
  "addx -9",
  "addx 1",
  "addx 1",
  "addx -3",
  "addx 11",
  "noop",
  "noop",
  "addx 1",
  "noop",
  "addx 1",
  "noop",
  "noop",
  "addx -13",
  "addx -19",
  "addx 1",
  "addx 3",
  "addx 26",
  "addx -30",
  "addx 12",
  "addx -1",
  "addx 3",
  "addx 1",
  "noop",
  "noop",
  "noop",
  "addx -9",
  "addx 18",
  "addx 1",
  "addx 2",
  "noop",
  "noop",
  "addx 9",
  "noop",
  "noop",
  "noop",
  "addx -1",
  "addx 2",
  "addx -37",
  "addx 1",
  "addx 3",
  "noop",
  "addx 15",
  "addx -21",
  "addx 22",
  "addx -6",
  "addx 1",
  "noop",
  "addx 2",
  "addx 1",
  "noop",
  "addx -10",
  "noop",
  "noop",
  "addx 20",
  "addx 1",
  "addx 2",
  "addx 2",
  "addx -6",
  "addx -11",
  "noop",
  "noop",
  "noop",
]

x = Device.new
print "Test Part 1: 13140 == "
p x.part1(TEST)

print "Part 1: "
p x.part1(File.read_lines("day_10.txt"))

print "Test Part 2: "
x.part2(TEST)

print "Part 2: "
x.part2(File.read_lines("day_10.txt"))
