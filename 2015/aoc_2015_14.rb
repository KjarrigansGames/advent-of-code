Reindeer = Struct.new :name, :fly_speed, :fly_time, :resting_time do
  def fly_distance_after(seconds:)
    distance = seconds / (fly_time + resting_time) * fly_time * fly_speed

    distance += [fly_time, (seconds % (fly_time + resting_time))].min * fly_speed
    distance
  end
end

def parse_reindeer(line)
  if line =~ /^(\w+) can fly (\d+) km\/s for (\d+) seconds, but then must rest for (\d+) seconds.$/
    return Reindeer.new($1, $2.to_i, $3.to_i, $4.to_i)
  end

  raise ArgumentError, "Invalid input data: #{line.inspect}"
end

def test_part1_works?
  comet = parse_reindeer('Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.')
  return false unless comet.fly_speed == 14
  return false unless comet.fly_time == 10
  return false unless comet.resting_time == 127
  return false unless comet.fly_distance_after(seconds: 1000) == 1120

  dancer = parse_reindeer('Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.')
  return false unless dancer.fly_speed == 16
  return false unless dancer.fly_time == 11
  return false unless dancer.resting_time == 162
  return false unless dancer.fly_distance_after(seconds: 1000) == 1056

  true
end

def solve_part1(deers)
  unless test_part1_works?
    warn "Specs for part 1 fail"
    binding.irb
  end

  ranking = deers.map do |deer|
    deer.fly_distance_after(seconds: 2503)
  end.sort.reverse
  puts "Part 1: #{ranking.first}"
end

def solve_part2(deers)
  ranking = Hash.new(0)
  (1..2503).each do |second|
    current_distances = deers.map do |deer|
      [deer.name, deer.fly_distance_after(seconds: second)]
    end.to_h
    current_leader = current_distances.values.max
    current_distances.each do |name, dist|
      ranking[name] += 1 if dist == current_leader
    end
  end
  puts "Part 2:"
  ranking.each do |name, points|
    puts format("%8s got %4d points", name, points)
  end
end

if __FILE__ == $0
  deers = DATA.readlines.map do |line|
    parse_reindeer(line.chomp)
  end
  solve_part1(deers)
  puts "--------------------------------------"
  solve_part2(deers)
end

__END__
Vixen can fly 8 km/s for 8 seconds, but then must rest for 53 seconds.
Blitzen can fly 13 km/s for 4 seconds, but then must rest for 49 seconds.
Rudolph can fly 20 km/s for 7 seconds, but then must rest for 132 seconds.
Cupid can fly 12 km/s for 4 seconds, but then must rest for 43 seconds.
Donner can fly 9 km/s for 5 seconds, but then must rest for 38 seconds.
Dasher can fly 10 km/s for 4 seconds, but then must rest for 37 seconds.
Comet can fly 3 km/s for 37 seconds, but then must rest for 76 seconds.
Prancer can fly 9 km/s for 12 seconds, but then must rest for 97 seconds.
Dancer can fly 37 km/s for 1 seconds, but then must rest for 36 seconds.
