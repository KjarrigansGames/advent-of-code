SAMPLE = "2199943210
3987894921
9856789892
8767896789
9899965678"

SAMPLE2 = "923459832127999987654321239763459
896598743236789898986430198654578
789679654345899769876521298767699
678989965456998754987694349878789
567899896587897653498989499989893
455698789698976542349878989998989
324997698789965431298767778997679
439876589899899549987658567896545
546987678998798998996543456789439
679898789987687567995432123678919"

# #1111#222222####3333333333#44444# 1-9
# 5#11#222222222#8#3#333333#4444444 2-38
# 55#11#2222222##88#3333333#44444## 3-32
# 555#1##22222##8888#333#333#44444# 4-24
# 5555##D#22222#88888#3#6#3###4#4#Y 5-24
# 5555#DDD#2#2#8888888#666#6###7#7# 6-40
# 555##DD#222##888888#6666666##777# 7-12
# 55#DDDDD#2##N##88##666666666#7777 8-28
# 555#DDDDD##NN#N##N##666666666#77# D-19
# 55#Z#DDD##NNNNNNNN##6666666666#7# N-13
#                                   Y-1
#                                   Z-1

EMPTY_LIST = {} of Int32 => Array(Array(Int32))

def risk_level(input, debug=false)
  low_points = [] of Int32

  height_map = input.split("\n").map { |line| line.scan(/(\d)/).map { |md| md[1].to_i32 } }
  height_map.each_with_index do |row, y|
    row.each_with_index do |height, x|
      neigh = [] of Int32
      neigh << height_map[y][x-1] if x-1 >= 0
      neigh << height_map[y][x+1] if x+1 < row.size
      neigh << height_map[y-1][x] if y-1 >= 0
      neigh << height_map[y+1][x] if y+1 < height_map.size
      if height < neigh.min
        puts "Low point found at (#{x},#{y}) - #{height} (#{neigh.join(',')})" if debug
        low_points << height
      end
    end
  end
  low_points.sum + low_points.size
end

def debug_map(grid, overlay)
  grid.each_with_index do |row, y|
    row.each_with_index do |v, x|
      if v == 9
        print '.'
      else
        bas = overlay.find { |a,b| b.includes?([x,y]) }
        raise "No wall and no Group is wrong! (#{x}, #{y})" if bas.nil?
        print (overlay.keys.index(bas.first) || -1).to_s(base: 36)
      end
    end
    puts
  end
end

def map_basins(input, debug=false)
  height_map = input.split("\n").map { |line| line.scan(/(\d)/).map { |md| md[1].to_i32 } }

  # Rowise L->R check
  # 11....2222
  # 1.333.2.22
  # .43333.5.2 <- Merge 4->3
  # 63333.755. <- Merge 6->3, Merge 7->5
  # .3...85555 <- Merge 8-> 5
  #
  # 11...22222
  # 1.333.2.22
  # .33333.4.2
  # 33333.444.
  # .3...44444

  basins = EMPTY_LIST.dup # This took me ages to find!!!! No dup = Giant clusters from previous runs
  next_basin = 0
  height_map.each_with_index do |row, y|
    next_basin += 1
    row.each_with_index do |height, x|
      if height == 9
        next_basin += 1
        next
      end

      # Is there a known basin up or left of here?
      basin = basins.find do |idx, list|
        list.includes?([x,y-1]) || list.includes?([x-1,y])
      end
      basin = basin.nil? ? next_basin : basin.first
      puts "(#{x},#{y}) | #{height} -> #{basin}" if debug
      basins[basin] ||= [] of Array(Int32)
      basins[basin] << [x,y]
    end
  end
  basins = merge_basins(basins, debug: debug)
  basins = merge_basins(basins, debug: debug)
  debug_map(height_map, basins) if debug

  top_3 = basins.map { |_idx, member| member.size }.sort[-3, 3]
  if debug
    basins.each { |key, mem| puts "Bas ##{(basins.keys.index(key) || -1).to_s(base: 36)} -> #{mem.size}" }
    p top_3
  end
  top_3.reduce { |a,b| a * b }
end

def merge_basins(basins, debug=false)
  basins.each do |key, members|
    puts "Check if #{key} (#{members.size}) can be merged with..." if debug
    members.each do |pos|
      bas = basins.find do |idx, list|
        next if idx == key

        # Is there a known basin up or left of here?
        list.includes?([pos[0],pos[1]-1]) || list.includes?([pos[0]-1,pos[1]])
      end
      next if bas.nil?

      if debug
        p pos, [pos[0],pos[1]-1], [pos[0]-1,pos[1]]
        p bas
        puts "Merge Partner found! #{key} -> #{bas.first}"
      end
      basins[bas.first] += (basins.delete(key) || [] of Array(Int32))
      break
    end
  end
  basins
end

print "Sample 15 == "
puts risk_level(SAMPLE)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts risk_level(input)

print "Sample 1134 == "
puts map_basins(SAMPLE)

print "Sample-2 48640 == "
puts map_basins(SAMPLE2, debug: false)

print "Part 2: "
puts map_basins(input)
