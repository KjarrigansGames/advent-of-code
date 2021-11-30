struct Triangle
  property a, b, c
  
  def initialize(@a : Int32, @b : Int32, @c : Int32)
  end
    
  def valid?
    a + b > c &&
    a + c > b &&
    b + c > a
  end
  
  def self.parse(line)
    sides = line.scan(/(\d+)/).map { |md| md[0].to_i32 }
    new(sides[0], sides[1], sides[2])
  rescue IndexError
    Triangle.new(0,0,0)
  end
end

def part1(input)
  triangles = input.split("\n").map_with_index do |spec, idx|
    Triangle.parse(spec)
  end

  print "Part 1: "
  puts triangles.count { |tri| tri.valid? }
end

def part2(input)
  col1 = [] of Int32
  col2 = [] of Int32
  col3 = [] of Int32
  input.scan(/(\d+)/).map { |md| md[0].to_i32 }.each_with_index do |val, idx|
    col1 << val if idx % 3 == 0
    col2 << val if idx % 3 == 1
    col3 << val if idx % 3 == 2
  end
  triangles = [] of Triangle
  list = [col1, col2, col3].flatten
  until list.empty?
    triangles << Triangle.new(list.shift, list.shift, list.shift)
  end
  
  print "Part 2: "
  puts triangles.count { |tri| tri.valid? }  
end

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt"))
part1(input)
part2(input)
