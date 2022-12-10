class Knot
  property x = 0
  property y = 0
  def initialize(@x = 0, @y = 0)
  end
  
  def +(other : Knot)
    Knot.new(@x + other.x, @y + other.y)
  end
  
  def -(other : Knot)
    Knot.new(@x - other.x, @y - other.y)
  end
  
  def move(direction)
    @x += direction.x.clamp(-1, 1)
    @y += direction.y.clamp(-1, 1)
    self
  end
  
  def adjacent?(other)
    direction = (self - other)
    (-1..1).includes?(direction.x) &&
      (-1..1).includes?(direction.y)
  end
  
  def to_s
    "K(#{@x},#{@y})"
  end
end

class Vector < Knot; end
  
RIGHT = Vector.new 1, 0
LEFT = Vector.new -1, 0
UP = Vector.new 0, -1
DOWN = Vector.new 0, 1

def part2(input, debug = false)
  tail_positions = [] of Knot
  head = Knot.new
  knots = (1..9).map do
    Knot.new 
  end
  
  tail_positions << head.dup

  input.each do |command|
    direction = case command
    when /R (\d+)/ then RIGHT
    when /L (\d+)/ then LEFT
    when /U (\d+)/ then UP
    when /D (\d+)/ then DOWN
    else
      raise "Invalid command: #{command.inspect}"
    end
    
    $1.to_i.times do
      head.move(direction)
      ref = head
      
      knots.each_with_index do |segment, tid|
        break if segment.adjacent?(ref)
        
        segment.move(ref - segment)
        ref = segment
        
        if tid == 8
          puts "Tail moved!" if debug
          tail_positions << segment.dup
        end        
      end
    end
  end
  
  show_debug(tail_positions) if debug
  
  tail_positions.map do |pos|
    pos.to_s
  end.uniq.size
end

def show_debug(pos)
  grid = Hash(Int32, Hash(Int32, Char)).new
  
  pos.each do |vec|
    grid[vec.y] ||= Hash(Int32, Char).new('.')    
    grid[vec.y][vec.x] = '#'
  end
  
  (grid.keys.min..grid.keys.max).each do |dy|
    c = grid.map { |_key, col| col.keys }.flatten
    (c.min..c.max).each do |dx|
      row = grid[dy]?
      print(row.nil? ? '.' : row[dx])
    end
    puts
  end
end

TEST = [
  "R 5",
  "U 8",
  "L 8",
  "D 3",
  "R 17",
  "D 10",
  "L 25",
  "U 20",
]

print "Test Part 2: 36 == "
p part2(TEST, debug: true)

print "Part 2: "
# 2667 is too high
p part2(File.read_lines("day_9.txt"), debug: true)
