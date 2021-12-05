require "math"

SAMPLE = "0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2"

def diagonal?(start, stop)
  (start[0] - stop[0]).abs == (start[1] - stop[1]).abs
end

def cloud_map(input, with_diagonals=false)
  max_x = input.scan(/(\d+),/).map { |md| md[1].to_i32 }.max + 1
  max_y = input.scan(/,(\d+)/).map { |md| md[1].to_i32 }.max + 1

  floor = [] of Array(Int32)
  max_y.times do |y|
    floor << Array.new(max_x, 0)
  end

  input.split("\n").each do |line|
    start, stop = line.split(" -> ")
    start = start.split(",").map { |coord| coord.to_i32 }
    stop = stop.split(",").map { |coord| coord.to_i32 }
    if start[0] == stop[0]
      a, b = [start[1], stop[1]].sort
      Range.new(a, b).each do |y|
        floor[y][start[0]] += 1
      end
      next
    end

    if start[1] == stop[1]
      a, b = [start[0], stop[0]].sort
      Range.new(a, b).each do |x|
        floor[start[1]][x] += 1
      end
      next
    end

    if with_diagonals && diagonal?(start, stop)
      dx = (stop[0] > start[0]) ? 1 : -1
      dy = (stop[1] > start[1]) ? 1 : -1

      pos = start
      until pos == stop
        floor[pos[1]][pos[0]] += 1
        pos[0] += dx
        pos[1] += dy
      end
      floor[pos[1]][pos[0]] += 1
    end
  end

  # debug_map(floor)

  floor.flatten.count { |val| val > 1 }
end

def debug_map(floor)
  floor.each do |row|
    puts row.map { |d| d == 0 ? '.' : d }.join(" ")
  end
end

print "Sample 5 == "
puts cloud_map(SAMPLE)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts cloud_map(input)

print "Sample 12 == "
puts cloud_map(SAMPLE, with_diagonals: true)

print "Part 2: "
puts cloud_map(input, with_diagonals: true)
