SAMPLE = "1163751742
1381373672
2136511328
3694931569
7463417111
1319128137
1359912421
3125421639
1293138521
2311944581"

SAMPLE2 = "29999999999999
11111119999999
99999919999999
99991119999999
99991999999999
99991999999999
99991111111111"

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

  def *(fak : Int32)
    Vector2.new(@x*fak, @y*fak)
  end

  def distance
    @x + @y
  end

  def to_s
    "(#{@x},#{@y})"
  end
end


DIRECTIONS = [
  Vector2.new( 1, 0), # E
  Vector2.new( 0, 1), # S
  Vector2.new(-1, 0), # W
  Vector2.new( 0,-1), # N
]
def djikstra(grid, start, stop)
  total_travel_cost = Map.new(999_999_999)
  total_travel_cost[start] = 0 # grid[start]
  max_x = stop.x
  max_y = stop.y

  queue = [start]

  loop do
    queue.sort! { |a,b| total_travel_cost[a] <=> total_travel_cost[b] }
    current_node = queue.shift

    current_cost = total_travel_cost[current_node]
    raise "Somethind is wrong. The initial cost should be set" if current_cost.nil?

    DIRECTIONS.each do |dir|
      pos = current_node + dir
      next unless pos.x >= 0 && pos.y >= 0 && pos.x <= max_x && pos.y <= max_y

      new_cost = current_cost + grid[pos]
      if total_travel_cost[pos] > new_cost
        total_travel_cost[pos] = new_cost
        queue << pos
      end

      return total_travel_cost[stop] if pos == stop
    end

    raise "Something is wrong. There should always be a valid possible move?" if queue.empty?
  end
end

alias Map = Hash(Vector2, Int32)
def part1(input)
  grid = Map.new(999_999)
  lines = input.split("\n")
  ex = lines.first.size
  ey = lines.size
  lines.each_with_index do |row, y|
    ex = row.size
    row.each_char.to_a.each_with_index do |travelcost, x|
      grid[Vector2.new(x, y)] = travelcost.to_i32
    end
  end

  djikstra(grid, Vector2.new(0, 0), Vector2.new(ex-1, ey-1))
end

def part2(input)
  grid = Map.new(999_999)
  lines = input.split("\n")
  ex = lines.first.size
  ey = lines.size

  lines.each_with_index do |row, y|
    row.each_char.to_a.each_with_index do |travelcost, x|
      5.times do |dx|
        5.times do |dy|
          pos = Vector2.new(ex*dx+x, ey*dy+y)
          raise "Position already set #{pos} | #{dx},#{dy}" if grid[pos] < 999_999

          cost = travelcost.to_i32 + dx + dy
          grid[pos] = cost > 9 ? cost - 9 : cost
        end
      end
    end
  end

  djikstra(grid, Vector2.new(0, 0), Vector2.new(ex*5-1, ey*5-1))
end

print "Sample 40 == "
puts part1(SAMPLE)

print "Sample 23 == "
puts part1(SAMPLE2)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)

print "Sample 315 == "
puts part2(SAMPLE)

print "Part 2: "
puts part2(input)
