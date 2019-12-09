class Intcode
  attr_reader :program
  attr_reader :pointer
  def initialize(*program)
    @program = program
    @pointer = 0
  end

  def next
    opcode = program[pointer].to_s.rjust(2, '0')
    case opcode.slice!(-2, 2)
    when /1/
#       p "Sum-Mode - #{pointer}"
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      set_value(pointer + 3, param_1 + param_2)
      @pointer += 4
    when /2/
#       p "Multiply-Mode - #{pointer}"
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      set_value(pointer + 3, param_1 * param_2)
      @pointer += 4
    when /3/
#       p "Input-Mode - #{pointer}"
      set_value(pointer + 1, STDIN.gets.chomp.to_i)
      @pointer += 2
    when /4/
#       p "Output-Mode - #{pointer}"
      output = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      STDOUT.puts output
      @pointer += 2
    when /5/
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      if param_1.zero?
        @pointer += 3
      else
        @pointer = param_2
      end
    when /6/
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      unless param_1.zero?
        @pointer += 3
      else
        @pointer = param_2
      end

    when /7/
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      value = param_1 < param_2 ? 1 : 0
      set_value(pointer + 3, value)
      @pointer += 4
    when /8/
      param_1 = get_value(pointer + 1, mode: opcode[-1, 1] || 0)
      param_2 = get_value(pointer + 2, mode: opcode[-2, 1] || 0)
      value = param_1 == param_2 ? 1 : 0
      set_value(pointer + 3, value)
      @pointer += 4
    when /99/
#       p "Exit-Mode"
      return false
    end
    true
  end

  def remaining_program
    program[pointer..-1]
  end

  def get_value(address, mode: 0)
    case mode.to_i
    when 0 then program[program[address]]
    when 1 then program[address]
    end
  end

  def set_value(address, value)
    program[program[address]] = value
  end
end

boosters = {}

#[0,1,2,3,4].permutation.each do |sequence|
[[9,8,7,6,5]].each do |sequence|
  STDIN = StringIO.new
  STDOUT = StringIO.new

  power = 0
  sequence.each do |step|
    warn "Amplifier: #{step}..."

    # int = Intcode.new(3,8,1001,8,10,8,105,1,0,0,21,38,55,72,93,118,199,280,361,442,99999,3,9,1001,9,2,9,1002,9,5,9,101,4,9,9,4,9,99,3,9,1002,9,3,9,1001,9,5,9,1002,9,4,9,4,9,99,3,9,101,4,9,9,1002,9,3,9,1001,9,4,9,4,9,99,3,9,1002,9,4,9,1001,9,4,9,102,5,9,9,1001,9,4,9,4,9,99,3,9,101,3,9,9,1002,9,3,9,1001,9,3,9,102,5,9,9,101,4,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,99,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,99,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,99)
    int = Intcode.new(3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5)
    3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10
    STDIN = StringIO.new [step, power, nil].join("\n")
    int.remaining_program while int.next
    p power = STDOUT.string.split.last
  rescue StandardError
    warn STDIN.string.inspect
    warn STDOUT.string.inspect
    exit
  end
  boosters[sequence] = power
end

p boosters.sort_by{|key, value| value.to_i }.first
p boosters.sort_by{|key, value| value.to_i }.last
