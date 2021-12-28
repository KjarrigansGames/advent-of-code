class DeterministicDie
  property current, counter
  def initialize
    @current = 0
    @counter = 0
  end
  
  def roll
    @counter += 1
    @current += 1
    @current = 1 if @current == 101
    @current
  end
end

struct Player 
  property score : Int32, pos : Int32
  def initialize(pos, @score)
    @pos = pos - 1
  end
  
  def move(num)
    @pos = (pos + num)  % 10
    @score += (pos + 1)
    @pos
  end
end

def part1(starting_pos : Array(Int32))
  player_1 = Player.new starting_pos[0], 0
  player_2 = Player.new starting_pos[1], 0
  die = DeterministicDie.new
  
  loop do
    num = [die.roll, die.roll, die.roll].sum  
    player_1.move(num)
    return (player_2.score * die.counter) if player_1.score >= 1000
  
    num = [die.roll, die.roll, die.roll].sum  
    player_2.move(num)
    return (player_1.score * die.counter) if player_2.score >= 1000
  end
end

print "Sample 739785 == "
puts part1([4, 8])

print "Part 1: "
puts part1([8, 5])
