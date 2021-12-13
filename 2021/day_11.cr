SAMPLE = "11111
19991
19191
19991
11111
"

SAMPLE2 = "5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526"

def debug_map(grid)
  grid.each do |row|
    puts row.join.tr("0", ".")
  end
  puts
end

struct Vector2
  property x, y
  def initialize(@x : Int32, @y : Int32)
  end
end

def reset_grid(grid)
  grid.each_with_index do |row, y|
    row.each_with_index do |level, x|
      grid[y][x] = 0 if level > 9
    end
  end
  grid
end

def tick(grid=[] of Array(Int32))
  flashed = [] of Vector2
  first_wave = true

  loop do
    something_flashed = false
    grid.each_with_index do |row, y|
      row.each_with_index do |level, x|
        pos = Vector2.new(x,y)
        grid[y][x] += 1 if first_wave

        if grid[y][x] > 9 && !flashed.includes?(pos)
          something_flashed = true
          flashed << pos
          [-1, 0, 1].each do |dy|
            [-1, 0, 1].each do |dx|
              next if dx == dy == 0
              next if (pos.x+dx) < 0 || (pos.y+dy) < 0

              grid[pos.y+dy][pos.x+dx] += 1
            rescue IndexError
              # puts "No grid point @ (#{pos.x+dx},#{pos.y+dy})"
            end
          end
        end
      end
    end
    first_wave = false
    break unless something_flashed
  end

  # Reset all points > 9 to 0

  [flashed.uniq.size, reset_grid(grid)]
end

def flashes(input, ticks=100, debug=false, abort_on_sync=false)
  grid = input.split("\n").map do |row|
    row.scan(/(\d)/).map { |num| num[1].to_i32 }
  end

  num = 0
  ticks.times do |step|
    counter, grid = tick(grid)
    raise "Counter broken: #{counter.inspect}" unless counter.is_a?(Int32)
    raise "Grid broken: #{counter.inspect}" unless grid.is_a?(Array(Array(Int32)))
    num += counter
    if debug
      puts "Flashed: #{counter} (#{num})"
      debug_map(grid)
    end

    return step+1 if abort_on_sync && grid.flatten.join.matches?(/^0+$/)
  end
  debug_map(grid) if debug
  raise "#{ticks} were not enough to find the correct sync step" if abort_on_sync

  num
end

print "Sample 9 == "
puts flashes(SAMPLE, ticks: 2)

print "Sample 204 == "
puts flashes(SAMPLE2, ticks: 10)

print "Sample 1656 == "
puts flashes(SAMPLE2, ticks: 100)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts flashes(input, ticks: 100)

print "Sample 195 == "
puts flashes(SAMPLE2, ticks: 200, abort_on_sync: true)
#
puts "Part 2: "
puts flashes(input, ticks: 1_000_000, abort_on_sync: true)
