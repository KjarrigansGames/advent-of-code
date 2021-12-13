struct Vector2
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end
end

SAMPLE ="6,10
0,14
9,10
0,3
10,4
4,11
6,0
6,12
4,1
0,13
10,12
3,4
3,0
8,4
1,10
2,14
8,10
9,0

fold along y=7
fold along x=5"

def debug_map(grid, fold_x=nil, fold_y=nil)
  max_x = grid.map { |vec| vec.x }.max
  max_y = grid.map { |vec| vec.y }.max

  (0..max_y).each do |y|
    (0..max_x).each do |x|
      next print('|') if x == fold_x
      next print('-') if y == fold_y
      print grid.includes?(Vector2.new(x,y)) ? '#' : '.'
    end
    puts
  end
end

def fold_x(grid, x)
  max_x = grid.map { |vec| vec.x }.max
  grid.map do |vec|
    vec.x -= 2*(vec.x - x) if vec.x > x
    vec
  end.uniq
end

def fold_y(grid, y)
  max_y = grid.map { |vec| vec.y }.max
  grid.map do |vec|
    vec.y -= 2*(vec.y - y) if vec.y > y
    vec
  end.uniq
end

def generate_code(input, part1=false)
  grid = [] of Vector2

  input.split("\n").each do |line|
    case line
    when /^$/
      next
    when /fold along x=(\d+)/
      grid = fold_x(grid, $~[1].to_i32)
      break if part1
    when /fold along y=(\d+)/
      grid = fold_y(grid, $~[1].to_i32)
      break if part1
    when /(\d+),(\d+)/
      grid << Vector2.new($~[1].to_i32, $~[2].to_i32)
    else
      raise "Invalid/Unparsed input: #{line.inspect}"
    end
  end

  return grid.size if part1

  debug_map(grid)
end

print "Sample 17 == "
puts generate_code(SAMPLE, part1: true)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts generate_code(input, part1: true)

print "Sample O == "
generate_code(SAMPLE)

puts "Part 2: "
generate_code(input)
