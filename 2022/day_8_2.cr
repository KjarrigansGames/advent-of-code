TEST = %w[
  30373
  25512
  65332
  33549
  35390
]

def generate_grid(input)
  grid = Array(Array(Int8)).new

  input.each do |row|
    data = Array(Int8).new
    row.strip.each_char do |tree|
      data << tree.to_i8
    end
    grid << data
  end

  grid
end
