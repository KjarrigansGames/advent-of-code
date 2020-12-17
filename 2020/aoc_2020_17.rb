require 'matrix'

ACTIVE = 1 # #
INACTIVE = 0 # .
infinite_grid = Hash.new(0)

direction_vectors = []
[-1, 0, 1].each do |w|
  [-1, 0, 1].each do |z|
    [-1, 0, 1].each do |x|
      [-1, 0, 1].each do |y|
        next if x == 0 && y == 0 && z == 0 && w == 0

        direction_vectors << Vector[x, y, z, w]
      end
    end
  end
end
p direction_vectors.size


DATA.each_with_index do |line, y|
  line.chomp.each_char.with_index(0) do |char, x|
    infinite_grid[Vector[x, y, 0, 0]] = char == '#' ? ACTIVE : INACTIVE
  end
end
p infinite_grid

# find the current bounds where an active cube is, because thats the condition to
# "grow" in these directions
6.times do
  new_grid = Hash.new(0)

  print "Current Active Cubes: "
  p infinite_grid.values.sum

  min_x = 0
  max_x = 0
  min_y = 0
  max_y = 0
  min_z = 0
  max_z = 0
  min_w = 0
  max_w = 0
  infinite_grid.each do |pos, state|
    next if state == INACTIVE

    min_x = [min_x, pos[0]].min
    max_x = [max_x, pos[0]].max
    min_y = [min_y, pos[1]].min
    max_y = [max_y, pos[1]].max
    min_z = [min_z, pos[2]].min
    max_z = [max_z, pos[2]].max
    min_w = [min_w, pos[3]].min
    max_w = [max_w, pos[3]].max
  end

  min_x -= 1
  max_x += 1
  min_y -= 1
  max_y += 1
  min_z -= 1
  max_z += 1
  min_w -= 1
  max_w += 1

  (min_w..max_w).each do |w|
    (min_z..max_z).each do |z|
      (min_x..max_x).each do |x|
        (min_y..max_y).each do |y|
          cube = Vector[x, y, z, w]
          current_state = infinite_grid[cube]

          active_neighbours = 0
          direction_vectors.each do |offset|
            active_neighbours += 1 if infinite_grid[cube + offset] == ACTIVE
            break if active_neighbours > 3
          end

          new_state = INACTIVE
          new_state = ACTIVE if current_state == ACTIVE && active_neighbours.between?(2,3)
          new_state = ACTIVE if current_state == INACTIVE && active_neighbours == 3

  #         binding.irb if z == -2 && new_state == ACTIVE

          new_grid[cube] = new_state
        end
      end
    end
  end
  infinite_grid = new_grid

  # Debugging
#   (min_z..max_z).each do |z|
#     puts "z=#{z}"
#     (min_y..max_y).each do |y|
#       (min_x..max_x).each do |x|
#         cube = Vector[x, y, z]
#         print infinite_grid[cube] == ACTIVE ? '#' : '.'
#       end
#       puts
#     end
#   end

#   binding.irb
end

print "Current Active Cubes: "
p infinite_grid.values.sum

__END__
.##.####
.#.....#
#.###.##
#####.##
#...##.#
#######.
##.#####
.##...#.
