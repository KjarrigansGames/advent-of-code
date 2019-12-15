require 'irb'
require 'io/console'

class Intcode
  attr_reader :program
  attr_reader :pointer
  attr_accessor :offset
  def initialize(*program)
    @program = program
    @pointer = 0
    @offset = 0
  end
  attr_accessor :io_inp, :io_out

  def next
    opcode = program[pointer].to_s.rjust(2, '0')
    case opcode.slice!(-2, 2)
    when /1/ # sum
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      set_value(pointer + 3, param_1 + param_2, mode: opcode[-3, 1] || 0)
      @pointer += 4
    when /2/ # multiply
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      set_value(pointer + 3, param_1 * param_2, mode: opcode[-3, 1] || 0)
      @pointer += 4
    when /3/ # input
      inp = io_inp.gets.chomp
#       warn "  |- Input: #{inp}"
      set_value(pointer + 1, inp.to_i, mode: opcode[-1, 1] || 0)
      @pointer += 2
    when /4/ # output
      output = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
#       warn "  |- Signal: #{output}"
      io_out.puts output
      @pointer += 2
    when /5/ # jump-if-non-zero
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      if param_1.zero?
        @pointer += 3
      else
        @pointer = param_2
      end
    when /6/ # jump-if-non-zero
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      unless param_1.zero?
        @pointer += 3
      else
        @pointer = param_2
      end
    when /7/ # less-than (1 = true, 0 = false)
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      value = param_1 < param_2 ? 1 : 0
      set_value(pointer + 3, value, mode: opcode[-3, 1] || 0)
      @pointer += 4
    when /8/ # compare (1 = equal, 0 = false)
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      value = param_1 == param_2 ? 1 : 0
      set_value(pointer + 3, value, mode: opcode[-3, 1] || 0)
      @pointer += 4
    when /99/ # halt
      return false
    when /9/ # set relative base
      @offset += get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      @pointer += 2
    else
      raise "Invalid opcode: #{opcode.inspect} at #{pointer}"
    end
    true
  end

  def remaining_program
    program[pointer..-1]
  end

  def wait_for_input?
    program[pointer].to_s.rjust(2, '0').to_i == 3
  end

  def output?
    program[pointer].to_s.rjust(2, '0').to_i == 4
  end

  def finished?
    program[pointer].to_s.rjust(2, '0').to_i == 99
  end

  def get_value(address, mode: 0)
    case mode.to_i
    when 0 then program[program[address]]
    when 1 then program[address]
    when 2 then program[program[address] + offset]
    end || 0
  rescue
    0
  end

  def set_value(address, value, mode: 0)
    case mode.to_i
    when 0 then program[program[address]] = value
    when 1 then raise "Invalid mode - set value can't be immediate"
    when 2 then program[program[address] + offset] = value
    end
  end
end

int = Intcode.new(3,1033,1008,1033,1,1032,1005,1032,31,1008,1033,2,1032,1005,1032,58,1008,1033,3,1032,1005,1032,81,1008,1033,4,1032,1005,1032,104,99,101,0,1034,1039,1001,1036,0,1041,1001,1035,-1,1040,1008,1038,0,1043,102,-1,1043,1032,1,1037,1032,1042,1106,0,124,1001,1034,0,1039,1001,1036,0,1041,1001,1035,1,1040,1008,1038,0,1043,1,1037,1038,1042,1106,0,124,1001,1034,-1,1039,1008,1036,0,1041,102,1,1035,1040,101,0,1038,1043,102,1,1037,1042,1105,1,124,1001,1034,1,1039,1008,1036,0,1041,101,0,1035,1040,1001,1038,0,1043,101,0,1037,1042,1006,1039,217,1006,1040,217,1008,1039,40,1032,1005,1032,217,1008,1040,40,1032,1005,1032,217,1008,1039,1,1032,1006,1032,165,1008,1040,3,1032,1006,1032,165,1101,0,2,1044,1105,1,224,2,1041,1043,1032,1006,1032,179,1102,1,1,1044,1106,0,224,1,1041,1043,1032,1006,1032,217,1,1042,1043,1032,1001,1032,-1,1032,1002,1032,39,1032,1,1032,1039,1032,101,-1,1032,1032,101,252,1032,211,1007,0,45,1044,1105,1,224,1101,0,0,1044,1106,0,224,1006,1044,247,1002,1039,1,1034,1002,1040,1,1035,1001,1041,0,1036,1002,1043,1,1038,102,1,1042,1037,4,1044,1106,0,0,7,39,95,7,98,8,11,47,17,33,19,4,29,41,87,34,59,22,75,5,1,46,41,29,32,11,55,25,53,41,77,27,52,33,41,65,72,24,43,83,72,3,14,92,2,43,82,30,87,19,94,47,91,10,8,67,24,4,68,85,63,4,93,29,55,34,23,65,40,3,36,90,57,97,37,2,65,8,1,16,83,93,67,44,71,97,27,70,76,20,40,90,36,73,27,89,57,13,66,37,95,76,26,84,33,48,34,86,85,30,81,6,61,33,83,84,22,21,67,27,11,49,28,69,41,60,98,6,69,41,54,82,18,37,65,10,42,47,41,2,72,16,66,39,93,37,2,41,52,49,20,78,30,7,38,15,40,81,21,14,82,44,48,7,96,33,36,70,52,18,71,1,81,66,47,1,38,78,80,38,63,53,80,16,58,55,93,31,89,36,36,78,65,71,34,83,4,55,60,29,10,30,84,15,59,31,96,16,21,58,26,38,35,58,50,16,46,25,26,82,59,12,11,98,4,17,42,66,83,72,23,14,92,22,9,5,87,5,79,85,19,87,71,28,61,32,56,92,56,19,78,94,39,24,73,58,28,37,81,11,99,25,46,73,44,5,22,41,76,55,84,31,16,36,65,84,40,29,81,66,16,94,23,54,23,29,51,20,25,23,69,44,23,18,99,80,55,39,10,71,7,33,63,94,93,62,26,35,25,50,61,39,84,38,54,43,56,23,67,17,70,34,23,90,93,24,46,60,31,46,33,53,81,10,62,23,89,86,43,39,73,82,38,9,61,42,66,68,30,28,95,4,25,54,22,21,80,32,61,13,6,66,47,59,4,31,59,17,87,72,30,72,51,30,30,62,43,53,88,42,48,13,21,80,8,30,61,14,77,22,27,60,87,30,65,14,33,76,67,9,95,26,84,40,21,52,11,86,23,30,86,57,28,6,69,4,11,63,21,2,65,51,39,58,82,16,51,96,23,3,44,21,62,31,38,47,73,30,29,94,24,14,88,1,51,72,42,57,48,63,33,95,78,15,17,68,64,61,10,31,58,68,36,15,52,19,13,26,38,72,41,66,15,56,88,18,98,87,15,43,89,96,3,94,55,25,26,27,6,48,3,29,90,88,6,18,29,88,90,43,3,81,61,16,31,93,42,26,46,31,56,66,17,76,37,15,50,33,81,16,10,83,87,37,39,92,80,62,6,59,77,9,32,91,61,97,24,44,62,61,11,36,94,59,54,34,23,67,18,86,31,39,77,73,44,67,27,57,5,54,65,29,21,81,2,65,39,24,82,6,55,33,97,72,35,16,85,19,28,57,94,21,15,86,5,52,53,39,69,20,32,52,5,86,95,44,47,77,9,57,14,62,49,54,7,70,29,16,42,87,99,30,36,67,68,14,42,73,4,87,97,39,61,18,11,39,77,83,17,83,27,1,72,30,21,95,38,35,96,15,78,27,66,40,4,95,90,94,4,20,63,71,19,54,11,28,96,46,13,42,94,84,9,22,79,37,14,50,13,58,64,90,30,69,18,20,90,4,21,31,95,88,22,81,36,20,11,82,59,95,38,43,72,3,78,38,33,62,48,36,22,16,3,87,53,91,37,12,19,49,18,25,14,67,78,79,9,70,88,34,98,38,8,90,98,56,13,26,34,82,77,40,97,82,63,32,57,26,58,53,29,56,3,62,17,78,67,69,33,49,62,47,36,60,9,81,12,96,6,78,86,98,34,70,41,87,86,47,15,46,36,49,20,76,31,48,1,68,19,96,0,0,21,21,1,10,1,0,0,0,0,0,0)
int.io_inp, virtual_inp = IO.pipe
virtual_out, int.io_out = IO.pipe

# Input Codes
# north (1), south (2), west (3), and east (4)

# Output Codes
# 0: The repair droid hit a wall. Its position has not changed.
# 1: The repair droid has moved one step in the requested direction.
# 2: The repair droid has moved one step in the requested direction; its new position is the location of the oxygen system.

Robot = Struct.new(:x, :y) do
  def pos
    [x, y]
  end
end
robot = Robot.new 0, 0
cursor = Robot.new 0, 0

def grid_to_map(grid)
  x_offset = grid.keys.map(&:first).min.abs + 5
  y_offset = grid.keys.map(&:last).min.abs + 3

  map = []
  grid.each do |pos, tile|
    map[pos[1] + y_offset] ||= Array.new
    map[pos[1] + y_offset][pos[0] + x_offset] = tile
  end

  # Add more undiscovered fields
  max_x = map.compact.map(&:size).max + 5
  dummy_array = Array.new(max_x).map{ '?' }

  3.times do
    map << dummy_array
  end

  map = map.map do |r|
    r = (r || dummy_array).map{ |t| t || '?' }.join
    r += '?' until r.size >= max_x
    r
  end
  puts map
rescue => err
  binding.irb
  raise err
end

grid = {[0,0] => 'o'}
puts grid_to_map(grid)

loop do
  int.next until int.wait_for_input?

  cursor = robot.dup
  case STDIN.getch
  when /w/
    virtual_inp.puts 1
    cursor.y -= 1
  when /s/
    virtual_inp.puts 2
    cursor.y += 1
  when /a/
    virtual_inp.puts 3
    cursor.x -= 1
  when /d/
    virtual_inp.puts 4
    cursor.x += 1
  when /q/ then exit
  when /i/
    binding.irb
    redo
  else redo
  end
  int.next
  int.next until int.output?
  int.next
  case virtual_out.gets.chomp
  when /0/
    grid[cursor.pos] = "#"
  when /1/
    grid[robot.pos] = " "
    robot.x = cursor.x
    robot.y = cursor.y
    grid[robot.pos] = "o"
  when /2/
    grid[robot.pos] = " "
    robot.x = cursor.x
    robot.y = cursor.y
    grid[robot.pos] = "X"
    binding.irb
  end

  system "clear"
  grid[[0,0]] = 'S'
  puts grid_to_map(grid)
end

__END__
###################################################
###################################################
###################################################
###################################################
######       #             #             #   ######
###### ##### # # # ####### # # ######### ### ######
######Z#     # # # #     # # # #       #   # ######
######## ### # # ### ### ### # # ### ##### # ######
######   #   # #   # # #     # # # #       # ######
###### ####### ### # # ####### # # ######### ######
###### #       # # #   #     # # #   #       ######
###### # ####### # ### # ### # # # # ##### # ######
###### #         #     #   #   #   #     # # ######
###### # ####### ######### ############# ### ######
######   #   # # #       # #   #       #   # ######
########## # # # # ### ### # ### ### ##### # ######
######     # #     #   #   #       #     #   ######
###### ##### ########### ### ####### # ##### ######
###### #   #       #   #   # #     # #     # ######
###### ### ####### # # # # ### ### ##### ### ######
######           #   # # #     #   #     #   ######
################ ##### # ####### ### ##### ########
######     # #   #   # #   #     # #     # # ######
###### ### # # ##### # ##### ##### # ### # # ######
###### #     #       # #  S#     #   # #   # ######
###### ##### ####### # # ### ### # ### ##### ######
######   #   #     # #   #   #   #   #   #   ######
###### # # ### ### # ######### ##### ### # # ######
###### # # #   #   # #     #   #   #   #   # ######
###### # # ##### ### ### # # ### # ### ### # ######
###### # #     # #   #   #   #   #   #   # # ######
###### # ##### # # ### ####### ##### ### ### ######
###### # #   # # # #   # #       #     #   # ######
###### # # ### # # ### # # ####### ### ### # ######
###### # #     # #     #       #   #     # # ######
######## # ##### ########### ### ### ##### # ######
######   # #     #         # #   # #   #   # ######
###### ### # ### # ####### ### ### # ### ### ######
###### #     #     #   #       #   # #   #   ######
###### # ######### # # ##### ##### # # ### # ######
###### # #   #   # # #     # #   #   #     # ######
###### ### # # # ### ##### ### # ########### ######
######     #   #         #     #             ######
###################################################
###################################################
###################################################
###################################################
