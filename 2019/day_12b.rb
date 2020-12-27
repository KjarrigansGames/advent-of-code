Coords = Struct.new(:x, :y, :z)

class Moon
    attr_accessor :position, :velocity

    def initialize(x, y, z)
        @position = Coords.new(x, y, z)
        @velocity = Coords.new(0, 0, 0)
    end

    def total_energy
        potential_energy * kinetic_energy
    end

    def apply_gravity!(compared_to)
        velocity.x += -(position.x <=> compared_to.position.x)
        velocity.y += -(position.y <=> compared_to.position.y)
        velocity.z += -(position.z <=> compared_to.position.z)
    end

    def apply_velocity!
        position.x += velocity.x
        position.y += velocity.y
        position.z += velocity.z
    end

    private

    def potential_energy
        sum_absolutes(position)
    end

    def kinetic_energy
        sum_absolutes(velocity)
    end

    def sum_absolutes(coord)
        coord.x.abs + coord.y.abs + coord.z.abs
    end
end

def tick!(moons)
    moons.combination(2).to_a.each do |from, to|
        from.apply_gravity!(to)
        to.apply_gravity!(from)
    end
    moons.each(&:apply_velocity!)
end

def parse_moon(str)
    x = str.match(/x=(-?\d+)/)[1].to_i
    y = str.match(/y=(-?\d+)/)[1].to_i
    z = str.match(/z=(-?\d+)/)[1].to_i
    Moon.new(x, y, z)
end

def read_inputs
    DATA.readlines.map(&:strip).map { |it| parse_moon(it) }
end

def hash_for(moon, axis)
    [moon.position.send(axis), moon.velocity.send(axis)].join('_')
end

def hash_all(moons, axis)
    moons.map { |it| hash_for(it, axis) }.join('x')
end

def main
    moons = read_inputs

    require 'set'

    results = [:x, :y, :z].map do |axis|
        previous_states = Set.new
        current_iteration = 0
        hashed = hash_all(moons, axis)
        while !previous_states.member?(hashed)
            previous_states.add(hashed)
            tick!(moons)
            hashed = hash_all(moons, axis)
            current_iteration += 1
        end
        current_iteration
    end
    puts results.inspect
    puts results.reduce(1, :lcm)
end

main

__END__
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
