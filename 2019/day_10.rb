require 'matrix'
require 'pmap'

inp = <<-INP
.#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....#...###..
..#.#.....#....##
INP

Asteroid = Struct.new :x, :y, :visible, :blocker do
  def to_s
    "P(#{x},#{y})"
  end

  def distance_to(other)
    Math.sqrt((other.x - self.x)**2 + (other.y - self.y)**2)
  end
end

list = []
inp.split.each_with_index do |row, y|
  row.chars.each_with_index do |char, x|
    list << Asteroid.new(x, y, 0) if char == '#'
  end
end
p list.size
p list

def m(p1, p2)
  x = (p2.x - p1.x.to_f)
  return false if x.zero?

  (p2.y - p1.y.to_f) / x
end

def b(dx, p2)
  p2.y - dx * p2.x
end

def func(p1, p2)
  # puts p1, p2
  return lambda {|p3| p3.y == p1.y } if p1.y == p2.y

  dx = m(p1, p2)
  return lambda {|p3| p3.x == p1.x } unless dx

  dy = b(dx, p2)
  lambda {|p3| dx*p3.x + dy == p3.y }
end

out = inp.dup.split

# list.each do |src|
#   puts src
#   s = Time.now
  src = list[28]
  # p src
  list.each_with_index do |tgt, idx|
    next src.visible += 1 if src == tgt

#     puts "-------------------------------------"
#     print src.to_s, ' --> '
#     puts tgt
    fx = func(src, tgt)

    blocked = list.find do |ast|
      next false if ast == src
      next false if ast == tgt
      break false if src.distance_to(tgt) < 1.5

      same_line = fx.call(ast)
      if same_line = fx.call(ast)
        print ast.to_s, ' --> '
        print src.distance_to(ast), ' < '
        puts src.distance_to(tgt)
      end
      same_line && src.distance_to(ast) < src.distance_to(tgt)
    end
    if blocked
#       tgt.blocker = true
    else
#       tgt.blocker = false
      src.visible += 1
    end
  end
  out[src.y][src.x] = 'A' # src.visible.to_s
# end

list.each do |pla|
  next if pla == src
  out[pla.y][pla.x] = pla.blocker ? '+' : '#'
end
puts out.join("\n")

# p list.find{|a| a.visible == 300 }
p list.map(&:visible).sort
# p 43
