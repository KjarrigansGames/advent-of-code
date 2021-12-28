SAMPLE = "on x=-20..26,y=-36..17,z=-47..7
on x=-20..33,y=-21..23,z=-26..28
on x=-22..28,y=-29..23,z=-38..16
on x=-46..7,y=-6..46,z=-50..-1
on x=-49..1,y=-3..46,z=-24..28
on x=2..47,y=-22..22,z=-23..27
on x=-27..23,y=-28..26,z=-21..29
on x=-39..5,y=-6..47,z=-3..44
on x=-30..21,y=-8..43,z=-13..34
on x=-22..26,y=-27..20,z=-29..19
off x=-48..-32,y=26..41,z=-47..-37
on x=-12..35,y=6..50,z=-50..-2
off x=-48..-32,y=-32..-16,z=-15..-5
on x=-18..26,y=-33..15,z=-7..46
off x=-40..-22,y=-38..-28,z=23..41
on x=-16..35,y=-41..10,z=-47..6
off x=-32..-23,y=11..30,z=-14..3
on x=-49..-5,y=-3..45,z=-29..18
off x=18..30,y=-20..-8,z=-3..13
on x=-41..9,y=-7..43,z=-33..15
on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
on x=967..23432,y=45373..81175,z=27513..53682"

SAMPLE2 = "on x=10..12,y=10..12,z=10..12
on x=11..13,y=11..13,z=11..13
off x=9..11,y=9..11,z=9..11
on x=10..10,y=10..10,z=10..10"

struct Vector3
  property x, y, z
  def initialize(@x : Int32, @y : Int32, @z : Int32)
  end

  def +(vec : Vector2)
    Vector2.new(@x+vec.x, @y+vec.y,@z+vec.z)
  end

  def to_s
    "(#{@x},#{@y},#{@z})"
  end
end

alias Grid3d = Hash(Vector3, Int8)
def part1(input)
  grid = Grid3d.new(0i8)
  
  input.split("\n").each do |line|
    md = line.match(/(on|off) x=([-0-9]+)..([-0-9]+),y=([-0-9]+)..([-0-9]+),z=([-0-9]+)..([-0-9]+)/)
    raise "Invalid input: #{line}" if md.nil?
    
    new_state = md[1] == "on" ? 1i8 : 0i8
    x1, x2 = md[2].to_i, md[3].to_i
    y1, y2 = md[4].to_i, md[5].to_i
    z1, z2 = md[6].to_i, md[7].to_i
    next if x1 > 50 || x2 < -50
    next if y1 > 50 || y2 < -50
    next if z1 > 50 || z2 < -50
    
    (x1..x2).each do |x|
      (y1..y2).each do |y|
        (z1..z2).each do |z|
          grid[Vector3.new(x,y,z)] = new_state
        end
      end
    end
  end

  sum = 0
  (-50..50).each do |x|
    (-50..50).each do |y|
      (-50..50).each do |z|
        sum += grid[Vector3.new(x,y,z)]
      end
    end
  end
  sum
end

struct Cuboid
  property x1 : Int32, x2 : Int32
  property y1 : Int32, y2 : Int32
  property z1 : Int32, z2 : Int32
  property on = 0
  def initialize(@x1, @x2, @y1, @y2, @z1, @z2)
    @on = (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  end
  
  def cut!(cube)
    if cube.x1 
    
    intersections = 0
    
    
    @on -= intersections
  end
end

def part2(input)
  list = [] of Cuboid
  input.split("\n").each do |line|
    md = line.match(/(on|off) x=([-0-9]+)..([-0-9]+),y=([-0-9]+)..([-0-9]+),z=([-0-9]+)..([-0-9]+)/)
    raise "Invalid input: #{line}" if md.nil?
    
    cube = Cuboid.new(
      md[2].to_i, md[3].to_i,
      md[4].to_i, md[5].to_i,
      md[6].to_i, md[7].to_i
    )
    if md[1] == "on"
      list << cube
    else
      list.each do |c|
        c.cut!(cube)
      end
    end
  end
  
  list.sum { |cube| cube.on }
end

# print "Sample 590784 == "
# puts part1(SAMPLE)
# 
# input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
# print "Part 1: "
# puts part1(input)

print "Sample 27 == "
puts part2(SAMPLE2)
