SAMPLE = "target area: x=20..30, y=-10..-5"

struct Rect
  property x1, y1, x2, y2
  def initialize(@x1 : Int32, @x2 : Int32, @y1 : Int32, @y2 : Int32)
  end

  def hit?(vec)
    vec.x >= @x1 && vec.x <= @x2 &&
    vec.y >= @y1 && vec.y <= @y2
  end

  def overshot?(vec)
    vec.x > @x2 || vec.y < @y1
  end

  def self.from_string(input)
    md = input.match(/x=(\d+)..(\d+), y=(-\d+)..(-\d+)/)
    raise ArgumentError.new(input.inspect) if md.nil?

    new(md[1].to_i32, md[2].to_i32, md[3].to_i32, md[4].to_i32)
  end

  def to_s
    "Rect(#{@x1},#{@y1},#{@x2},#{@y2})"
  end
end

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

def trick_shot(force,target, pos=Vector2.new(0,0))
  max_y = pos.y
  loop do
    pos += force
    max_y = [max_y, pos.y].max

    if target.overshot?(pos)
      # puts "Overshot #{force} @ #{pos}"
      return false
    end

    if target.hit?(pos)
      # puts "Hit #{force} @ #{pos}"
      return max_y
    end

    force.x += (force.x < 0 ? 1 : -1) if force.x != 0
    force.y -= 1
  end
end

def part1_try1(input)
  target = Rect.from_string input

  force = Vector2.new(1,1)
  ideal_force = force

  # in theorey 45° are ideal for fartest throw so start with that and find the first throw that matches
  until trick_shot(force, target)
    force += Vector2.new(1,1)

    raise "No good starting position found" if force.x > (target.x1 / 2)
  end

  # Now tweak the diagonal a bit
  max_y = trick_shot(force, target)
  raise "Invalid Starting Position" unless max_y.is_a?(Int32)

  (0..10).each do |dx|
    last_y = max_y
    tweak = force.dup
    tweak.x -= dx

    # TODO, The brute force attempt revelead that I already found the "perfect" x but it stopped
    # trying the y-coord. So there seems to be an slight frame where it didn't hit...
    while last_y.is_a?(Int32)
      if last_y > max_y
        max_y = last_y
        ideal_force = tweak
      end

      tweak.y += 1
      last_y = trick_shot(tweak, target)
    end
  end

  p ideal_force

  max_y
end

def part1(input)
  max_y = 0
  ideal_force = Vector2.new(0,0)

  target = Rect.from_string input
  # We want to go high so < x is better
  (1..(target.x1 / 2)).each do |fx|
    (0..200).each do |fy|
      force = Vector2.new(fx, fy)
      new_y = trick_shot(force, target)
      next unless new_y

      if new_y.is_a?(Int32) && new_y > max_y
        ideal_force = force
        max_y = new_y
      end
    end
  end

  p ideal_force
  max_y
end

def part2(input)
  hit = 0
  target = Rect.from_string input
  (0..400).each do |dx|
    (-200..500).each do |dy|
      hit += 1 if trick_shot(Vector2.new(dx,dy), target)
    end
  end
  hit
end

print "Sample V(6,9) -> 45 == "
puts part1_try1(SAMPLE)
puts part1(SAMPLE)

input = "target area: x=156..202, y=-110..-69"
print "Part 1: "
# Wrong: 1431
puts part1_try1(input)
puts part1(input)

print "Sample 112 == "
puts part2(SAMPLE)

print "Sample 112 == "
puts part2(input)
