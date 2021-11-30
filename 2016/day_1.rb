class Day1
  attr_accessor :debug
  attr_reader :pos, :direction, :path
  def initialize
    @debug = false
  end
  
  def reset
    @direction = :north
    @pos = [0, 0]    
    @path = []
  end

  def turn(rot)
    @direction = case @direction
                when :north
                  rot == 'L' ? :west : :east
                when :south
                  rot == 'L' ? :east : :west
                when :east
                  rot == 'L' ? :north : :south
                when :west
                  rot == 'L' ? :south : :north
                else
                  binding.irb
                end
    puts "Now facing: #{@direction}" if debug
  end

  def walk(speed)
    case @direction
    when :north
      speed.times do |i|
        @pos[1] += 1
        path << @pos.clone
      end
    when :south
      speed.times do |i|
        @pos[1] -= 1
        path << @pos.clone
      end      
    when :east
      speed.times do |i|
        @pos[0] += 1
        path << @pos.clone
      end
    when :west
      speed.times do |i|
        @pos[0] -= 1
        path << @pos.clone
      end      
    else
      binding.irb
    end
    puts "Now at: #{@pos}" if debug
  end
  
  def solve_part1(input)
    reset
    input.split(', ').each do |ins|
      turn ins[0,1]
      walk ins[1..-1].to_i
    end
    distance = @pos[0].abs + @pos[1].abs

    puts "Shortest Path: #{distance}" if debug
    distance
  end

  def solve_part2(input)
    solve_part1(input)
    shortcut = path.tally.find{ |pos, visited| visited > 1 }[0]
    distance = shortcut[0].abs + shortcut[1].abs

    puts "Shortest Path: #{distance}" if debug
    distance
  end  
end

puzzle = Day1.new
raise 'Invalid Solution!' if puzzle.solve_part1('R2, L3') != 5
raise 'Invalid Solution!' if puzzle.solve_part1('R2, R2, R2') != 2
raise 'Invalid Solution!' if puzzle.solve_part1('R5, L5, R5, R3') != 12


input = DATA.read
print 'Solution Part 1: '
puts puzzle.solve_part1(input)

raise 'Invalid Solution!' unless puzzle.solve_part2('R8, R4, R4, R8') == 4
print 'Solution Part 2: '
puts puzzle.solve_part2(input)

__END__
L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1
