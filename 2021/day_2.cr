SAMPLE = "forward 5
down 5
forward 8
up 3
down 8
forward 2"

class Submarine
  property x = 0
  property depth = 0
  property aim = 0

  def move(command)
    case command
    when /forward (\d+)/ then @x += $1.to_i
    when /down (\d+)/ then @depth += $1.to_i
    when /up (\d+)/ then @depth -= $1.to_i
    else
      raise "Invalid command: #{command}"
    end
  end

  def move_aimed(command)
    case command
    when /forward (\d+)/
      @x += $1.to_i
      @depth += ($1.to_i * @aim)
    when /down (\d+)/ then @aim += $1.to_i
    when /up (\d+)/ then @aim -= $1.to_i
    else
      raise "Invalid command: #{command}"
    end
  end
end

def part1(input)
  sub = Submarine.new
  input.chomp.split("\n").each do |cmd|
    sub.move(cmd)
  end
  sub.x * sub.depth
end

def part2(input)
  sub = Submarine.new
  input.chomp.split("\n").each do |cmd|
    sub.move_aimed(cmd)
  end
  sub.x * sub.depth
end

print "Sample 150 == "
puts part1(SAMPLE)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)

print "Sample 900 == "
puts part2(SAMPLE)

print "Part 2: "
puts part2(input)
