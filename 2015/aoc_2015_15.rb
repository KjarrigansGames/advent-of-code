require 'matrix'

Ingredient = Struct.new :name, :capacity, :durability, :flavor, :texture, :calories do
  def self.parse(string)
    name, properties = string.split(': ')
    ing = new name

    properties.scan(/([a-z]+) ([-0-9]+)/).each do |prop, value|
      ing.send("#{prop}=", value.to_i)
    end
    ing
  end

  def *(val)
    Vector[
      capacity,
      durability,
      flavor,
      texture
    ] * val
  end
end

def perfect_calories?(ing, i1, i2, i3, i4, calorie_cap:)
  (ing[0].calories * i1 + ing[1].calories * i2 + ing[2].calories * i3 + ing[3].calories * i4) == calorie_cap
end

def perfect_cookie_receipt(ingredients, total_spoons: 100, calorie_cap: false)
  metrics = {}

  (1..99).map do |i1|
    (1..99).map do |i2|
      (1..99).map do |i3|
        i4 = 100 - i1 - i2 - i3
        next if i4 < 1
        next if calorie_cap && !perfect_calories?(ingredients, i1, i2, i3, i4, calorie_cap: calorie_cap)
        p

        (
          ingredients[0] * i1 +
          ingredients[1] * i2 +
          ingredients[2] * i3 +
          ingredients[3] * i4
        ).inject { [0, _1].max * [0, _2].max }
      end
    end
  end.flatten.compact.sort.last
end

def test_part1
  ing = []
  ing << Ingredient.parse('Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8')
  ing << Ingredient.parse('Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3')

  return false unless (ing[0] * 44 + ing[1] * 56).inject(:*) == 62842880

  perfect_cookie_receipt(ing) == 62842880
end

if __FILE__ == $0
#   unless test_part1
#     warn "Part 1 specs fail"
#     binding.irb
#   end
  ing = DATA.readlines.map { Ingredient.parse _1.chomp }
  print "Part 1: "
  puts perfect_cookie_receipt ing

  print "Part 2: "
  puts perfect_cookie_receipt ing, calorie_cap: 500
end

__END__
Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8
