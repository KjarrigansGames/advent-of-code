SAMPLE = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#

#..#.
#....
##..#
..#..
..###"

SCAN_MATRIX = [
  Vector2.new(-1, -1),
  Vector2.new( 0, -1),
  Vector2.new( 1, -1),
  
  Vector2.new(-1, 0),
  Vector2.new( 0, 0),
  Vector2.new( 1, 0),
  
  Vector2.new(-1, 1),
  Vector2.new( 0, 1),
  Vector2.new( 1, 1),
]

struct Vector2
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end

  def +(vec : Vector2)
    Vector2.new(@x+vec.x, @y+vec.y)
  end

  def -(vec : Vector2)
    Vector2.new(@x-vec.x, @y-vec.y)
  end

  def to_s
    "(#{@x},#{@y})"
  end
  
  def <=>(other)
    [@x, @y] <=> [other.x, other.y]
  end
end

alias Image = Hash(Vector2, Int8)
def parse_input(input)
  lines = input.split("\n")
  conway = lines[0]
  raise "Invalid Input: #{conway.size}" if conway.size != 512
  
  grid = Image.new(0)
  lines[2..-1].each_with_index do |row, y|
    row.each_char_with_index do |val, x|
      grid[Vector2.new(x, y)] = val == '#' ? 1i8 : 0i8
    end
  end
  
  return grid, conway
end

# My input contains an # on Idx 0 so in theory the image gets instantly flooded with lights everywhere so I can't just "grow" by 1 in either direction
# 20333 is too high with (x1-1..x2+1) | (y1-1..y2+1)
# 20026 is not right
# 18594 is too low with (x1-1..x2+1) | (y1-1..y2+1) and replacing idx 0 of my input with an .
def bounding_box(grid)
  top_left = grid.keys.min
  bottom_right = grid.keys.max
  # v1: see above
  grow_top_left = Vector2.new(-1, -1)
  grow_bottom_right = Vector2.new(1, 1)
  
  # v2: only grow if there is at least 1 lit pixel -> there always is so it basically v1Does any
  # grow_top_left = Vector2.new(
  #   (top_left.y..bottom_right.y).map { |dy| grid[Vector2.new(top_left.x, dy)] }.includes?(1) ? -1 : 0, # Left Border
  #   (top_left.x..bottom_right.x).map { |dx| grid[Vector2.new(dx, top_left.y)] }.includes?(1) ? -1 : 0, # Upper Border
  # )
  # grow_bottom_right = Vector2.new(
  #   (top_left.y..bottom_right.y).map { |dy| grid[Vector2.new(bottom_right.x, dy)] }.includes?(1) ? 1 : 0, # Right Border
  #   (top_left.x..bottom_right.x).map { |dx| grid[Vector2.new(dx, bottom_right.y)] }.includes?(1) ? 1 : 0, # Lower Border
  # )
  
  # v3 only grow if top_left/bottom_right is lit, obviously false but I'm running out of ideas...
  # grow_top_left = grid[top_left] == 1 ? Vector2.new(-1, -1) : Vector2.new(0, 0)
  # grow_bottom_right = grid[bottom_right] == 1 ? Vector2.new(1, 1) : Vector2.new(0, 0)
  
  # v4 seeking lowest and highest x,y altough this should be equivalent to pos.min/max -> and it is
  return [
    Vector2.new(
      grid.keys.map { |pos| pos.x }.min - 1,
      grid.keys.map { |pos| pos.y }.min - 1
    ),
    Vector2.new(
      grid.keys.map { |pos| pos.x }.max + 1,
      grid.keys.map { |pos| pos.y }.max + 1
    )
  ]
  
  return [top_left + grow_top_left, bottom_right + grow_bottom_right]
end

def tick(grid : Image, conway : String, blinking=false)
  top_left, bottom_right = bounding_box(grid)
  
  new_grid = Image.new(blinking ? 1i8 : 0i8)
  (top_left.y..bottom_right.y).each do |y|
    (top_left.x..bottom_right.x).each do |x|
      pos = Vector2.new(x, y)
      idx = SCAN_MATRIX.map do |dir| 
        grid[pos + dir] 
      end.join.to_i(2)
      new_grid[pos] = conway[idx] == '#' ? 1i8 : 0i8
    end
  end
  
  new_grid
end

def part1(input, ticks=2)
  grid, con = parse_input(input)
  
  ticks.times do |tick|
    grid = tick(grid, con, blinking: con[0] == '#' && tick % 2 == 0)
  end
  
  grid.values.tally[1]
end

print "Sample 35 == "
puts part1(SAMPLE, ticks: 2)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input, ticks: 2)

print "Sample 3351 == "
puts part1(SAMPLE, ticks: 50)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 2: "
puts part1(input, ticks: 50)
