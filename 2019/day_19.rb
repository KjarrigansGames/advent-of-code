require 'irb'
require 'io/console'
require 'stringio'

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

def get(x, y)
  int = Intcode.new(109,424,203,1,21102,11,1,0,1106,0,282,21102,18,1,0,1106,0,259,2102,1,1,221,203,1,21102,1,31,0,1106,0,282,21101,0,38,0,1106,0,259,21001,23,0,2,22101,0,1,3,21101,1,0,1,21102,57,1,0,1106,0,303,2101,0,1,222,21002,221,1,3,20102,1,221,2,21101,259,0,1,21101,0,80,0,1105,1,225,21102,1,83,2,21101,0,91,0,1105,1,303,1202,1,1,223,20102,1,222,4,21101,259,0,3,21101,225,0,2,21102,1,225,1,21101,118,0,0,1106,0,225,21002,222,1,3,21101,179,0,2,21102,1,133,0,1105,1,303,21202,1,-1,1,22001,223,1,1,21101,0,148,0,1105,1,259,1202,1,1,223,21001,221,0,4,20101,0,222,3,21102,1,19,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21102,1,195,0,105,1,109,20207,1,223,2,21002,23,1,1,21102,-1,1,3,21102,214,1,0,1106,0,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,2101,0,-4,249,21201,-3,0,1,21202,-2,1,2,22101,0,-1,3,21101,0,250,0,1106,0,225,22101,0,1,-4,109,-5,2106,0,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2106,0,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,21202,-2,1,-2,109,-3,2105,1,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,21201,-2,0,3,21101,343,0,0,1105,1,303,1106,0,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,21201,-4,0,1,21101,384,0,0,1106,0,303,1105,1,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,21202,1,1,-4,109,-5,2105,1,0)
  int.io_inp, comm = IO.pipe
  int.io_out = StringIO.new
  comm.puts x
  comm.puts y
  int.next until int.finished?
  int.io_out.string.chomp
end

def grid(width, height, start_x, start_y)
  grid = Array.new(height).map{ Array.new(width) }
  grid.map!.with_index do |row, y|
    y += start_y
    row.map!.with_index do |ele, x|
      x += start_x
      get(x, y)
    end
  end
end

# Part 1
puts grid(50, 50, 0, 0).map(&:join)
binding.irb
exit

x = 49
y = 36

# Part 2
loop do
  puts "New Startpoint: #{x},#{y}"
  dx = 0
  dy = 0
  dz = 0
  100.times do |offset|
    gx = get(x+offset, y)x
    gx == '1' ? dx += 1 : break

    gy = get(x, y-offset)
    gy == '1' ? dy += 1 : break

    gz = get(x+offset, y-99)
    gz == '1' ? dz += 1 : break
  end

  if dx == 100 && dy && 100 && dz == 100
    print "P(#{x}, #{y-99})"
    break
  end

  y += 1
  x += 1 until get(x, y) == '1'

  break if x == 10_000
end

binding.irb
