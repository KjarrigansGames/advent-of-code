class Vector
  property x : Int32
  property y : Int32

  def initialize(@x = 0, @y = 0)
  end

  def +(other : Vector)
    Vector.new(@x + other.x, @y + other.y)
  end

  def -(other : Vector)
    Vector.new(@x - other.x, @y - other.y)
  end

  def move!(other : Vector)
    @x += other.x
    @y += other.y
    self
  end

  def adjacent?(other)
    (@x - other.x).abs <= 1 &&
      (@y - other.y).abs <= 1
  end

  def normalize
    Vector.new(
      @x.clamp(-1, 1),
      @y.clamp(-1, 1)
    )
  end

  def to_s
    "V(#{@x},#{@y})"
  end
end

UP = Vector.new 0, -1
DOWN = Vector.new 0, 1
LEFT = Vector.new -1, 0
RIGHT = Vector.new 1, 0

TEST = [
  "R 4",
  "U 4",
  "L 3",
  "D 1",
  "R 4",
  "D 1",
  "L 5",
  "R 2",
]

def part1(input)
  head = Vector.new
  tail = Vector.new
  visited_spots = [] of Vector
  visited_spots << tail

  input.each do |command|
    direction = case command
    when /R (\d+)/ then RIGHT
    when /L (\d+)/ then LEFT
    when /U (\d+)/ then UP
    when /D (\d+)/ then DOWN
    else
      raise "Invalid movement: #{command}"
    end
    $1.to_i.times do
      head += direction
      next if head.adjacent?(tail)

      # print "Head: "
      # p head
      # print "Tail: "
      # p tail
      # print "Movement: "
      # p (tail - head).normalize
      # p "-----------------------------"

      tail += (head - tail).normalize
      visited_spots << tail
    end
  end

  visited_spots.uniq.size
end

TEST2 = [
  "R 5",
  "U 8",
  "L 8",
  "D 3",
  "R 17",
  "D 10",
  "L 25",
  "U 20",
]

def part2(input)
  head = Vector.new
  knots = [
    Vector.new,
    Vector.new,
    Vector.new,
    Vector.new,
    Vector.new,
    Vector.new,
    Vector.new,
    Vector.new,
    Vector.new,
  ]
  visited_spots = [] of Vector
  visited_spots << knots[8]

  input.each do |command|
    direction = case command
    when /R (\d+)/ then RIGHT
    when /L (\d+)/ then LEFT
    when /U (\d+)/ then UP
    when /D (\d+)/ then DOWN
    else
      raise "Invalid movement: #{command}"
    end
    $1.to_i.times do
      head += direction
      ref = head

      knots.each_with_index do |knot, idx|
        break if ref.adjacent?(knot)

        knot.move!((ref - knot).normalize)
        ref = knot

        if idx == 8
          # p "Tail moved"
          visited_spots << knots[8].dup
        end
      end

    end
  end

  visited_spots.uniq.size
end

print "Test Part 1: 13 == "
p part1(TEST)

print "Part 1: "
p part1(File.read_lines("day_9.txt"))

print "Test Part 2: 1 == "
p part2(TEST)

print "Test2 Part 2: 36 == "
p part2(TEST2)

print "Part 2: "
# 2667 is too high
p part2(File.read_lines("day_9.txt"))
