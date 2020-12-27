Moon = Struct.new :x, :y, :z, :a, :b, :c do
  def apply
    self.x += a
    self.y += b
    self.z += c
  end
end

def calculate_gravity(moon, other)
  dx = moon.x <=> other.x
  moon.a -= dx
  other.a += dx

  dy = moon.y <=> other.y
  moon.b -= dy
  other.b += dy

  dz = moon.z <=> other.z
  moon.c -= dz
  other.c += dz
end

moons = []
moons << Moon.new(-6, 2, -9, 0, 0, 0  )
moons << Moon.new(12, -14, -4, 0, 0, 0)
moons << Moon.new( 9, 5, -6, 0, 0, 0  )
moons << Moon.new(-1, -4, 9, 0, 0, 0  )
# moons << Moon.new(-1,   0,  2, 0, 0, 0)
# moons << Moon.new( 2, -10, -7, 0, 0, 0)
# moons << Moon.new( 4,  -8,  8, 0, 0, 0)
# moons << Moon.new( 3,   5, -1, 0, 0, 0)
# moons << Moon.new(-8, -10,  0, 0, 0, 0)
# moons << Moon.new( 5,   5, 10, 0, 0, 0)
# moons << Moon.new( 2,  -7,  3, 0, 0, 0)
# moons << Moon.new( 9,  -8, -3, 0, 0, 0)

phase = 0
history = { x: [], y: [], z: [] }
kx = ky = kz = ''
loop do
  # break if phase == 100

  calculate_gravity moons[0], moons[1]
  calculate_gravity moons[0], moons[2]
  calculate_gravity moons[0], moons[3]
  calculate_gravity moons[1], moons[2]
  calculate_gravity moons[1], moons[3]
  calculate_gravity moons[2], moons[3]

  kx = ky = kz = ''
  moons.each do |m|
    m.apply
    kx += [m.x, m.a].join('_')
    ky += [m.y, m.b].join('_')
    kz += [m.z, m.c].join('_')
  end
#   break if phase == 3000
  history[:x] = phase if history[:x].is_a?(Array) && history[:x].include?(kx)
  history[:y] = phase if history[:y].is_a?(Array) && history[:y].include?(ky)
  history[:z] = phase if history[:z].is_a?(Array) && history[:z].include?(kz)
  break unless history.any?{|x| x.is_a?(Array) }

  history[:x] << kx if history[:x].is_a?(Array)
  history[:y] << ky if history[:y].is_a?(Array)
  history[:z] << kz if history[:z].is_a?(Array)

  phase += 1
  puts phase if phase % 10_000 == 0
#   break if phase == 6000
end

binding.irb
