TEST = [
  "30373",
  "25512",
  "65332",
  "33549",
  "35390",
]

class Grid 
  @grid = Array(Array(Int8)).new
  property debug = false
  
  property highest_left = Hash(Int32, Int8).new(-1i8)
  property highest_top = Hash(Int32, Int8).new(-1i8)
  property highest_right = Hash(Int32, Int8).new(-1i8)
  property highest_bottom = Hash(Int32, Int8).new(-1i8)
  
  def initialize(@debug = false)
  end
  
  def parse(input)
    @grid = input.map do |row|
      list = [] of Int8
      row.each_char do |col|
        list << col.to_i8
      end
      list
    end
  end
  
  def to_s
    @grid.each do |row|
      puts row.join
    end
  end
  
  def visible_from_outside
    visible = [] of String
    width = @grid.first.size
    height = @grid.size
    
    # Scan Top and Left together
    @grid[0..-2].each_with_index do |row, rid|
      row[0..-2].each_with_index do |tree, cid|
        tree_id = "#{cid},#{rid}|#{tree}"
        
        if tree > highest_left[rid]
          if debug
            print "Found left y=#{rid}. #{highest_left[rid]} >"
            p tree_id
          end
          visible << tree_id
          highest_left[rid] = tree
        end
        
        if tree > highest_top[cid]
          if debug
            print "Found top x=#{cid}. #{highest_top[cid]} >"
            p tree_id
          end
          visible << tree_id
          highest_top[cid] = tree
        end
      end
    end
    
    # Can bottom and right together
    @grid.reverse[0..-2].each_with_index do |row, rid|
      row.reverse[0..-2].each_with_index do |tree, cid|
        tree_id = "#{width - cid - 1},#{height - rid - 1}|#{tree}"
        
        if tree > highest_right[rid]
          if debug
            print "Found right y=#{width - rid - 1}. #{highest_left[rid]} >"
            p tree_id
          end
          visible << tree_id
          highest_right[rid] = tree
        end
        
        if tree > highest_bottom[cid]
          if debug
            print "Found bottom x=#{height - cid - 1}. #{highest_bottom[cid]} >"
            p tree_id
          end
          visible << tree_id
          highest_bottom[cid] = tree
        end
      end
    end    
    
    show_debug_grid(visible) if debug
    
    visible.uniq.size + 2
  end
  
  def red(char)
    "\u001b[31;1m#{char}\u001b[0m"
  end
  
  def show_debug_grid(visible)
    @grid.each_with_index do |row, rid|
      row.each_with_index do |tree, cid|
        tree_id = "#{cid},#{rid}|#{tree}"
        print(visible.includes?(tree_id) ? red(tree) : tree)
      end
      puts
    end
  end
  
  def calculate_scenic_score(x, y, tree)
    width = @grid.first.size
    height = @grid.size
    
    # Scan right
    score = [0, 0, 0, 0]
    (x + 1).upto(width-1).each do |dx|
      score[0] += 1
      break if @grid[y][dx] >= tree
    end
    
    # Scan left
    (x - 1).downto(0).each do |dx|
      score[1] += 1
      break if @grid[y][dx] >= tree
    end
    
    # Scan down
    (y + 1).upto(height-1).each do |dy|
      score[2] += 1
      break if @grid[dy][x] >= tree
    end
    
    # Scan up
    (y - 1).downto(0).each do |dy|
      score[3] += 1
      break if @grid[dy][x] >= tree
    end
    
    return score[0] * score[1] * score[2] * score[3]
  end
  
  def best_spot
    best_score = 0
    best_position = "0,0|0"
    
    @grid.each_with_index do |row, rid|
      row.each_with_index do |tree, cid|
        score = calculate_scenic_score(cid, rid, tree)
        if score > best_score
          best_score = score 
          best_position = "#{cid},#{rid}|#{tree}"
        end
      end
    end
    
    p best_position
    best_score
  end
end

g = Grid.new
g.parse TEST

print "Test Part 1: 21 == "
p g.visible_from_outside

print "Test Part 2: 8 == "
p g.best_spot

g = Grid.new
g.parse File.read_lines("day_8.txt")
# 1909 is too high
# 1758 is not right
print "Part 1: "
p g.visible_from_outside

print "Part 2: "
p g.best_spot
