class Tile < Array
  WIDTH = HEIGHT = 10
  def borders
    @borders ||= [
      top_border, # Top
      bottom_border, # Bottom
      right_border,
      left_border, # Left
      top_border.reverse, # Top
      bottom_border.reverse, # Bottom
      left_border.reverse, # Left
      right_border.reverse # Right
    ]
  end

  def top_border
    self[0]
  end

  def bottom_border
    self[-1]
  end

  def right_border
    self.map { _1[-1] }.join
  end

  def left_border
    self.map { _1[0] }.join
  end

  def yflip!
    reverse!
  end

  def xflip!
    each{ _1.reverse! }
  end

  def lrotate!
    transpose!.yflip!
  end

  def rrotate!
    transpose!.xflip!
  end

  def transpose!
    tmp = map{ _1.each_char.to_a }.transpose
    map!.with_index do |rows, y|
      rows.each_char.map.with_index do |_, x|
        tmp[y][x]
      end.join
    end
  end

  def align!(tile, placement = :right)
    ref = right_border

    if tile.top_border == ref
      tile.lrotate!
    elsif tile.bottom_border == ref
      tile.rrotate!
    elsif tile.left_border == ref
      tile
    elsif tile.right_border == ref
      tile.x.flip!
    elsif tile.top_border.reverse == ref
      tile.lrotate!.yflip!
    elsif tile.bottom_border.reverse == ref
      tile.rrotate!.yflip!
    elsif tile.left_border.reverse == ref
      tile.flip!
    elsif tile.right_border.reverse == ref
      tile.xflip!.yflip!
    else
      raise "No common border found!"
    end

    tile.fixed = true
    tile
  end

  attr_accessor :fixed
end

TILES = {}

current_tile = []
DATA.each do |inp|
  inp.chomp!

  if inp =~ /Tile (\d+):/
    current_tile = $1.to_i
    TILES[current_tile] ||= Tile.new
    next
  end
  next current_tile = nil if inp.empty?

  TILES[current_tile] << inp
end

neighbors = {}

TILES.each do |id, tile|
  neighbors[id] = []
  TILES.each do |cid, candidate|
    next if cid == id
    neighbors[id] << cid unless (tile.borders & candidate.borders).empty?
  end
end

print "Part 1: "
p neighbors.sort_by { |_,v| v.size }[0,4].to_h.keys.inject(&:*)

# Pick any corne, than fill in the pattern like this
# Check neighbor 1
# Check neighbor 2
# They have 2 fields in common the corner and the field missing. The other fields
# form the new corner. Example:
# Corner is 3557:
# 3557 3739
# 1061
#
# Check 1061: [3557, 2551, 1913]
# Check 3739: [3557, 2551, 2347]
#
# So fill in the pattern an you got new corners to check:
# 3557 3739 2347
# 1061 2551
# 1913
#
# Thanks to manuel I build the map in a little less than 2 hours...
map = [
  %w[3557 3739 2347 3469 2179 1933 3677 1741 3613 2389 3691 1097],
  %w[1061 2551 2843 3119 3121 1039 1213 1499 1783 2017 1861 3923],
  %w[1913 3061 2699 1181 3517 2549 1889 1009 3673 3331 1987 2999],
  %w[3907 1367 3049 3761 1949 1597 3767 2617 3407 2803 2683 2797],
  %w[1427 3301 2003 3163 3169 2741 1621 2801 2441 2927 2399 1409],
  %w[1559 2657 2069 1487 3083 2713 1693 2693 2087 1493 1583 3359],
  %w[1511 3527 1753 1483 1847 3257 3643 3671 3697 3079 1733 1327],
  %w[2887 2957 3541 1283 1789 3659 1289 2083 2557 2477 2663 2309],
  %w[2029 1307 1543 1973 3109 1901 3637 3989 1867 1811 1447 3361],
  %w[2593 1291 2333 1657 2879 1723 2143 3797 1381 1567 1223 2917],
  %w[2423 2851 2473 3041 3821 1579 3037 1049 1997 3299 2749 1823],
  %w[1019 2777 1171 2297 1163 3181 2539 2647 1663 1553 3089 3769],
]
# p map
def print_map(map)
  txt = File.new('./aoc_2020_20_2_unrotated.map', 'w+')
  map.each do |columns|
    10.times do |row|
      columns.each do |tile_id|
        txt.print TILES[tile_id.to_i][row], ' '
        print TILES[tile_id.to_i][row], ' '
      end
      txt.puts
      puts
    end
    txt.puts
    puts
  end
end

def map_without_borders(map)
  txt = File.new('./aoc_2020_20_2_final.map', 'w+')
  map.each do |columns|
    10.times do |row|
      next if row == 0
      next if row == (Tile::HEIGHT-1)
      columns.each do |tile_id|
        txt.print TILES[tile_id.to_i][row][1,Tile::WIDTH-2]
        print TILES[tile_id.to_i][row][1,Tile::WIDTH-2]
      end
      txt.puts
      puts
    end
  end
end

# And again manuel helped a lot. I did this one tile at a time with `watch 'cat map'" and a second loop calling the code every seconds
# So I could see each flip and stuff I did
TILES[1511].rrotate!.xflip!
TILES[2887].rrotate!.xflip!
TILES[2029]
TILES[2593].lrotate!
TILES[2423].lrotate!
TILES[1019].lrotate!.yflip!

TILES[3527].xflip!
TILES[2957].yflip!
TILES[1307].yflip!
TILES[1291].lrotate!.xflip!
TILES[2851].xflip!.yflip!
TILES[2777].rrotate!.yflip!

TILES[1753].lrotate!.xflip!
TILES[3541].xflip!
TILES[1543].yflip!
TILES[2333]
TILES[2473].lrotate!
TILES[1171].rrotate!.yflip!

TILES[1483]
TILES[1283].rrotate!.xflip!
TILES[1973]
TILES[1657].xflip!
TILES[3041].yflip!
TILES[2297].lrotate!

TILES[1847].lrotate!.xflip!
TILES[1789].lrotate!.xflip!
TILES[3109].xflip!.yflip!
TILES[2879].rrotate!.xflip!
TILES[3821].rrotate!.xflip!
TILES[1163].rrotate!.xflip!

TILES[3257]
TILES[3659]
TILES[1901].rrotate!.yflip!
TILES[1723]
TILES[1579].xflip!
TILES[3181].lrotate!

TILES[3643].rrotate!.xflip!
TILES[1289].yflip!
TILES[3637].xflip!
TILES[2143].rrotate!.yflip!
TILES[3037].lrotate!.lrotate!
TILES[2539].lrotate!

TILES[3671].lrotate!
TILES[2083].yflip!
TILES[3989].yflip!.xflip!
TILES[3797].xflip!
TILES[1049]
TILES[2647].lrotate!

TILES[3697].yflip!.xflip!
TILES[2557].xflip!
TILES[1867].yflip!
TILES[1381].xflip!
TILES[1997].yflip!
TILES[1663].rrotate!.xflip!

TILES[3079]
TILES[2477]
TILES[1811].rrotate!.xflip!
TILES[1567].yflip!
TILES[3299].lrotate!
TILES[1553].lrotate!

TILES[1733].yflip!
TILES[2663].lrotate!
TILES[1447].rrotate!.xflip!
TILES[1223].lrotate!.lrotate!
TILES[2749].rrotate!.xflip!
TILES[3089].yflip!.xflip!

TILES[1327]
TILES[2309].yflip!
TILES[3361].xflip!
TILES[2917].yflip!
TILES[1823]
TILES[3769].yflip!.xflip!

# Col 0, Row 0 - 6
TILES[3557].lrotate!.yflip!
TILES[1061].yflip!.xflip!
TILES[1913]
TILES[3907].lrotate!.xflip!
TILES[1427]
TILES[1559].lrotate!

# Col 1, Row 0 - 6
TILES[3739].lrotate!.yflip!
TILES[2551].xflip!
TILES[3061].xflip!
TILES[1367].rrotate!.xflip!
TILES[3301].lrotate!
TILES[2657].yflip!

# Col 2, Row 0 - 6
TILES[2347].lrotate!
TILES[2843].rrotate!.yflip!
TILES[2699].xflip!.yflip!
TILES[3049].rrotate!.yflip!
TILES[2003].lrotate!.xflip!
TILES[2069]

# Col 3, Row 0 - 6
TILES[3469].yflip!
TILES[3119].xflip!
TILES[1181]
TILES[3761].yflip!
TILES[3163].rrotate!.rrotate!
TILES[1487]
TILES[1483]

# Col 4, Row 0 - 6
TILES[2179].yflip!
TILES[3121]
TILES[3517].lrotate!
TILES[1949].lrotate!
TILES[3169].xflip!
TILES[3083].lrotate!.lrotate!

# Col 5, Row 0 - 6
TILES[1933].lrotate!.lrotate!
TILES[1039].lrotate!.xflip!
TILES[2549].lrotate!.xflip!
TILES[1597].lrotate!
TILES[2741].xflip!
TILES[2713]
TILES[3257]

# Col 6, Row 0 - 6
TILES[3677].lrotate!.xflip!
TILES[1213].lrotate!.xflip!
TILES[1889].yflip!
TILES[3767].yflip!.xflip!
TILES[1621].yflip!
TILES[1693].lrotate!

# Col 7, Row 0 - 6
TILES[1741]
TILES[1499].yflip!
TILES[1009].rrotate!.xflip!
TILES[2617].rrotate!.xflip!
TILES[2801].rrotate!.xflip!
TILES[2693].yflip!.xflip!

# Col 8, Row 0 - 6
TILES[3613].xflip!
TILES[1783]
TILES[3673].rrotate!.xflip!
TILES[3407].lrotate!.xflip!
TILES[2441].yflip!.xflip!
TILES[2087].rrotate!.xflip!

# Col 9, Row 0 - 6
TILES[2389].rrotate!.rrotate!
TILES[2017].yflip!
TILES[3331].xflip!
TILES[2803].lrotate!
TILES[2927]
TILES[1493].lrotate!.xflip!

# Col 10, Row 0 - 6
TILES[3691].xflip!
TILES[1861].xflip!
TILES[1987].rrotate!.xflip!
TILES[2683].yflip!
TILES[2399].xflip!
TILES[1583].lrotate!.xflip!

# Col 11, Row 0 - 6
TILES[1097].yflip!.xflip!
TILES[3923].lrotate!.xflip!
TILES[2999].yflip!.xflip!
TILES[2797].yflip!.xflip!
TILES[1409].xflip!
TILES[3359].xflip!

#print_map(map)
#map_without_borders(map)

MONSTER =
# MONSTER = /###(....)##(....)##(....)#/
# final_map = File.readlines('./aoc_2020_20_2_final.map').map(&:chomp)

# final_map = final_map.map{ _1.each_char.to_a }.transpose.map(&:join).reverse.join("\n")

# final_map.gsub!(/#(....)##(....)##(....)###/, '0\100\200\3000')
# final_map.gsub!(/(.)#(..)#(..)#(..)#(..)#(..)#(...)/, '\10\20\30\40\50\6')
# File.write('./aoc_2020_20_2_final_with_monster.map', final_map)
print "Part 2: "
p File.read('./aoc_2020_20_2_final_with_monster.map').count('#')

__END__
Tile 2473:
.#.##.#.##
.......#..
.####.##..
#...###..#
...#.....#
#........#
.##.##...#
........##
#.##...#.#
.#####.#.#

Tile 3257:
##.#..###.
.##...#...
#.#.#...#.
#...#...##
##.#.....#
..#....#..
...#..##..
..##.....#
...###....
##.#..####

Tile 1049:
..##...###
#........#
#.#..#...#
.........#
....#.....
.....##..#
..#.###.#.
..#......#
.##.#..#..
.###....##

Tile 3109:
..#..##.#.
........#.
##.#..##.#
##...#.#..
.##.#...#.
...#......
#.##..##..
.....#..##
#..#.#.#..
..######.#

Tile 1409:
.###.#.#..
........##
.........#
..........
..#......#
#.#..#.#.#
#.#...#.##
..#..##...
.........#
#..#..#...

Tile 1949:
#..#.###..
.....#.#..
#...#.....
##.#....##
#......#..
#...#.#..#
#...#..#..
.###..####
#.#......#
.#...#.#..

Tile 2999:
####.#.##.
..##..##.#
..##.##.#.
#...#...##
#..#...###
.##..##...
##..#.##.#
#..#.....#
...#......
###....#..

Tile 1867:
###.##....
.#.#....##
##.....#.#
###......#
#.....#...
#....#.#..
...#....#.
#...#.##.#
..#....#.#
.##.#.#..#

Tile 2539:
#.#.##.##.
#.........
#....#..##
#..#...#.#
....#.#..#
.##..##...
#....##..#
#.........
.........#
..#..####.

Tile 2801:
.#.#.#....
#..#..#..#
..##....##
###....#.#
##.......#
..........
...##....#
#.##......
#.....##.#
.....#.#..

Tile 3079:
.####..###
#.#.....#.
...#..#..#
........#.
#........#
..#......#
#...###...
###...##.#
........#.
...#..##..

Tile 1621:
.##.#.....
.#.....##.
##.#....#.
....#.....
###....#.#
.#.....##.
.........#
##........
..#......#
#.#.#..##.

Tile 3989:
##.#...###
.......###
#..#..#...
#.......##
#.#..##...
##.#.....#
..#..#..##
#.#..#..#.
.#...#.#..
..#######.

Tile 3691:
..##.#####
#......#..
#......#..
#...#....#
#...#.....
##..##....
###.....#.
##.......#
.#...#...#
##.##.###.

Tile 2551:
.###.#..#.
......##.#
.....#..#.
.....#.#..
......#.#.
##.#.....#
#...#..#.#
......#.##
#...##....
.#.##..#.#

Tile 2557:
.##...#.#.
#.........
##........
#....#.#.#
.#.#...#.#
.#####...#
#..#......
#....#....
.#...#....
#..#.#.##.

Tile 1381:
....##.###
#.#....#..
..........
.#...###..
..#..#...#
..#..#...#
..........
..#......#
#.........
#.....#..#

Tile 1447:
...#######
#..#..#..#
..#..#####
.#...##...
.#.##....#
.#..#..#..
....#.....
#.##...###
#...#.....
#.....#.#.

Tile 1987:
.#.###....
.........#
#.#..#..##
.#.##....#
...##..#..
#..##.....
........#.
.###.#...#
.#....###.
..##.##.#.

Tile 2297:
###.#.#.#.
...#....#.
.....#..##
....#....#
#.....#..#
.#........
###.#.##.#
........#.
#...##..#.
.##.....#.

Tile 3697:
.##...#.#.
....#...##
##...###.#
#.#.#.....
...##....#
#.#....#..
...#.#.#..
.......#.#
#.........
.######.#.

Tile 2143:
.#..#...##
..#.#..###
.......##.
#.#....#.#
...#......
#...#.....
##..###..#
#...##....
#.........
##...#.#.#

Tile 3673:
######.#.#
#.......##
##..#..#.#
........##
.......#..
..#.#..#..
...#..#...
..#...##.#
.##..#..##
...#.##.#.

Tile 3613:
....#.###.
#.#....#..
#..#......
####...###
.#.#....#.
#.........
.......#.#
#.........
#......#.#
.##....###

Tile 1823:
..##.....#
........#.
..#.##...#
.........#
.........#
#......##.
....##..##
.......#.#
.......#.#
....#.#..#

Tile 1559:
.#.....#.#
.........#
..#....#.#
..#.....##
#..#......
##.....#..
....###.#.
#.#..#.#..
#..#...#..
.##.##..##

Tile 3083:
#.##.##.##
..#....#..
#.#.#...#.
#.##..#..#
#........#
...#......
#..##..#..
..#..#.#..
#.#......#
#.#####.##

Tile 3739:
..#.#.#.#.
#..#..#.##
......##..
...#......
.......###
....#.....
..#.#..###
#........#
.#.......#
.#.##.###.

Tile 3557:
..###.####
..........
#..#.#..##
##........
#..##....#
#.#......#
.#....#...
..#...#.#.
#...###..#
..#.#.#.#.

Tile 1289:
##.#.###..
#..#.#....
#.##...#.#
..#...#.#.
##........
#...##....
....#...#.
.......#..
#...#.....
##.#.#.#..

Tile 3769:
..####.#..
#......#.#
#........#
#....#.#..
.#....#...
......###.
#....#.#.#
#.#....#.#
##..#.#...
#..#.#....

Tile 1733:
........#.
....#.....
#.#.#.....
.#......##
#.##....##
#.........
......#...
###..#.##.
.#.......#
#..##..##.

Tile 2087:
..##....#.
#........#
##.#....#.
.........#
#........#
##..#..#.#
.#....#.##
...#.#.#.#
.........#
##..#..##.

Tile 2309:
###......#
......#...
#.#......#
.#.#.....#
...#.....#
##..#.#...
.#....#..#
###.#....#
#.##.#....
....#..#.#

Tile 1511:
..####...#
...#..#...
..#.#...#.
..........
#......#.#
#.....#...
..#......#
#.#....#.#
##.##..#..
.####.#...

Tile 1553:
####.#.###
#...#...##
...#....##
####......
...#..#...
#.#......#
.##.....##
#....#..##
..###..#.#
#...#.#.##

Tile 2017:
.###....#.
##..#..#..
#.....###.
##.#...##.
#..#.....#
....#....#
....#..#..
.#.#.....#
#.......#.
.###.##...

Tile 1291:
#....#.###
..........
.#.#.#..#.
....#...##
.#...#...#
#...#.#.#.
.#.....#..
#.....####
.##.#..##.
...#......

Tile 2797:
.###.#.#..
#...##...#
#..#......
#.##..#..#
...#.##...
...###....
..#..#....
.....#...#
....####..
####.#.##.

Tile 2879:
.#.###..##
#.##.....#
....####.#
#...##...#
#.#....#..
......#...
.#..#..#.#
##..#.##..
.........#
.#...#.##.

Tile 1723:
.#..##.###
#.##......
......#.##
..#.#.#...
........##
#...##..#.
...#......
###..#.#..
##.#....##
.#..#..###

Tile 2441:
#...##.##.
#.##..###.
.#.#.....#
..###.....
...##....#
##.##..#..
#..##...#.
.###.#.##.
.#.##..##.
.###...##.

Tile 2741:
#####..##.
.###.#....
#..#.#...#
.#..#.#...
.#....##.#
##.......#
.#.##.##..
#....#.##.
....##...#
...###..##

Tile 1283:
.##.#..##.
.....##...
#..#...#..
#..####...
.##....##.
##.#.....#
#.......##
#.#.#.....
.....##..#
###.#..#.#

Tile 3761:
#####.#..#
.......##.
#...#####.
#...#.##.#
##........
#......#.#
#..#.#..##
...#.#..##
.#........
...##..##.

Tile 3119:
.#.###.#.#
....#....#
......#...
.#.##..##.
.#.#......
#...#...#.
.##.......
##......##
#.##...###
######.##.

Tile 1973:
.....##.##
##.##...#.
.###...#.#
...#.##...
#..#.#....
....####..
#..###....
.#..#....#
##..#.##..
..##...#..

Tile 3407:
.#..##....
###.#....#
#...##...#
#....##...
.#..#.##..
..........
.........#
#....#...#
###....#.#
.###.#..##

Tile 2803:
.#..##....
..##.##..#
.....#.#.#
##.#...#..
#..#..#..#
###.#.###.
..#......#
#.#....#..
#........#
.#.#..###.

Tile 3821:
#...#..##.
#..#......
##......#.
#.........
....##...#
.#........
###.##...#
........#.
###..#.#..
..##.#.#..

Tile 1889:
.#...#....
..#..#.#.#
#.#...#..#
##........
........#.
.#....##..
##.##.#..#
..#.......
...#...#.#
##.#.#####

Tile 2333:
#.##..#.#.
###.#.#...
#.....#.#.
......##.#
###....#..
...##..#.#
..##.....#
..#.##....
....##....
#..#######

Tile 1307:
..#..##..#
#.##......
.#.....#.#
........##
##........
.#..#..#..
##.#.....#
#.....#...
#.##.##...
######.#..

Tile 2593:
##.###.###
.......#.#
..#..#....
#.#...#...
#.#.......
#.....#...
###...#...
.....#....
##.#..###.
...#......

Tile 1543:
#.##..#.#.
...##..#.#
#..#..#...
#..#..#..#
....#.#...
..#..#...#
#####..#..
..#.......
.#...#..##
.##.#.##..

Tile 2851:
...#.##.##
#....#....
..#..#..##
#......##.
#.##.#.##.
..#......#
##.#.....#
......#..#
##.......#
#....#.#..

Tile 3299:
##..##...#
#.....#..#
#....#....
.#...#..##
....##....
#....#..##
#...##.###
#..##..#.#
##.#..#.##
####.##...

Tile 1913:
####...###
.....#.#..
..........
#...#....#
#........#
#.....#..#
.#........
#......#..
......#...
###...##.#

Tile 3361:
#......###
#...#...#.
...#.#....
..........
......#.#.
#...##....
.#...#.#.#
....#...#.
..#.....##
.####..##.

Tile 3517:
...#.###.#
.#.#..#...
...####...
#...#....#
....#...##
#..#..##.#
.##..#..#.
##..#.##.#
#.#.#....#
.#.##.#.#.

Tile 2083:
.#######..
..####.#..
#.........
......###.
.#.......#
....#....#
....#....#
...#...##.
...##..#..
..#####...

Tile 1327:
..#.###...
#...#...##
..........
......##.#
.##.#.....
#...##.#.#
###..#..##
.....#....
...##.....
....#..#.#

Tile 1789:
..#.##...#
.#.#....#.
###...#...
#.#......#
#....#...#
#........#
#.......#.
##.#..#...
.###.#...#
#.#..#.###

Tile 3797:
##.#...###
....#...##
........#.
.....##...
#.........
#.#..#...#
...#....#.
#.##...##.
.....#.###
###...##..

Tile 1171:
###.#.#.#.
.....#...#
#.#.......
.#.#..##..
.....#.###
...#...#..
...#######
..#.....#.
####......
##...###..

Tile 2003:
...#...###
#..#......
##.##...##
###.......
#.......##
##.##.....
#....#.###
.#........
##.#.###..
#....##..#

Tile 1597:
.#...#.#..
##...##..#
##.#.###..
.#..##....
....###.#.
#.....##.#
###.#...##
#..#...#..
#.#..#...#
#####..#..

Tile 2179:
..#.#.####
..##.#.##.
.#.......#
#.#.##.#..
.....#....
###......#
#.#..#.#..
.###.#....
.......#..
.#.#...###

Tile 1997:
##.##....#
...##.#..#
##.#......
.#..#.#...
##.....#.#
..#......#
#.....#.#.
##...#.#..
##.....##.
#..#.....#

Tile 1163:
.#.....##.
.#...#...#
...#......
..........
##...#....
..##......
#.....#..#
..#......#
..........
.####...##

Tile 1933:
#.##.#####
#...#.....
#.#...#.##
.....#....
.....#....
#...#.#.##
..........
...#.##.#.
....#.....
.#..######

Tile 3359:
#..#..#...
.#..#..#..
.##......#
#..#.#..##
##..#....#
#...#..#..
...#.###..
..#..#...#
...##.#...
...###.#..

Tile 1499:
#.#.##.###
.###.....#
...###....
##....#...
#..##....#
.......###
#.......##
.....#..##
.........#
#.#.#..###

Tile 1663:
###.##.##.
#..#.#....
...#......
##...#...#
#..##.##.#
........##
......#...
.#..#..#..
.......#..
###.#.####

Tile 1493:
##.###....
#..##....#
#.#.......
....#.##.#
.....#...#
#.#.......
#...#....#
#.......##
#.##..#...
.##..#..##

Tile 1427:
#..#.##.##
##..#.....
.....#...#
...#....#.
......##.#
#.#.......
.#.##..#..
#.....#..#
##..###...
####.....#

Tile 2663:
..###.###.
##...#.#..
....#..#..
.....#....
..........
..#.......
..#.#.....
#..#......
###..#...#
#.#..#.##.

Tile 3089:
.#.#..#.##
#.........
##........
...#.#....
.##..#.#.#
.#....#...
##.##....#
#.#.......
..#.#.#..#
..##...#.#

Tile 3121:
..#.#.####
.###......
.###.#..#.
.#........
.#.#....#.
###...##.#
..#..##.##
###.......
##..#.#..#
#..###.##.

Tile 1567:
##.#.####.
#....#....
.#...#..##
......##.#
.........#
......#.#.
........#.
........##
#...#.##..
...#.#..##

Tile 2957:
######.#..
.#....#...
###.#.....
.#...#...#
...#..#..#
..#...#...
#.#......#
....####..
##.....#.#
.###......

Tile 2617:
..####....
...##....#
###.#..#..
#.##...###
....#....#
#.........
#....#....
.....#...#
#.#..#..##
##..#.###.

Tile 1847:
#....###.#
...#....#.
..###....#
#....##.##
#.....#...
##...#.###
.........#
.....##...
###..##..#
##..#.##.#

Tile 1753:
...#..####
.......#.#
..#.......
......#...
........#.
#.........
##....#.##
#.##....#.
.##.#..#..
..###..##.

Tile 2549:
..##..#..#
#..##.....
...#.#....
##........
#..#.....#
......#..#
...##....#
...#.#..##
#.##.....#
.#.##.#.#.

Tile 2917:
..##.....#
.#.......#
..##..#..#
..##......
.....##.##
.......##.
#....###..
.#..#.....
#......#.#
.##..####.

Tile 3301:
#.#..#.#.#
#.#.#..###
#.##....#.
.......#..
#........#
##.#.....#
.......###
..##.....#
.....#....
#....##..#

Tile 3041:
..###.#...
#..#.#.#.#
#...###..#
##..#.....
###...#...
#...#....#
......#...
#####.#...
..........
####.#####

Tile 2693:
.#..#..##.
#...####..
.#......##
..........
..#......#
.#..###.#.
#.#.....#.
#...###.##
.##.....##
.#.#.####.

Tile 3037:
.#.#.###..
.#....#...
.#.....#.#
.......#.#
..........
........##
.##..#....
#..#....#.
#.#...#..#
...#.#####

Tile 2399:
.....####.
##....##.#
##.....#..
........#.
#...#...##
#.#......#
#..#.....#
.....##...
#.#......#
....#..##.

Tile 1811:
###...###.
......#.#.
#.#.......
###.##...#
##......#.
#..#..#..#
...#....#.
....##....
#..#..#.##
...#######

Tile 3659:
##.#..####
...#...#.#
.#.....#..
..#..#....
#.......##
#......#.#
.......#..
#.......##
.....#.#.#
.##.#...##

Tile 3643:
...##..#.#
.#.####.##
.#..#..#..
#..####.##
#.#.#.....
....#....#
.....#....
#........#
.##..##...
..##.#....

Tile 2647:
..#..####.
##..#.##.#
......##.#
#..#....##
.##.......
......#...
#...#.....
........#.
...###...#
.##.##.###

Tile 2699:
..#.#.##.#
#....##...
###...#..#
#.#...##.#
..........
#...#.#..#
#......#..
#...#.#...
###.#.#...
..###.##..

Tile 3541:
.....###..
#......###
#.......#.
.....#..##
#......#..
......##.#
...##.####
#..#.#.#..
#..#......
..##.#.##.

Tile 3923:
#..#.#.###
#.#.....#.
#...##....
..#.###..#
.#..##....
.##..##..#
..........
#...##..#.
.##.#..##.
....#....#

Tile 1019:
###..#..##
.##..####.
...#....##
#...##...#
.......#.#
.....##...
#.#...#...
##.......#
#.....##.#
###.#..###

Tile 1741:
#.#.#...#.
#.....#...
..........
#....##.##
#.....#.#.
#...#.....
.....#..##
.###...##.
#.....#..#
#.#.#..###

Tile 2843:
.##.....##
........##
#.....#..#
#####..#.#
#........#
.##.#....#
#..#.##..#
##..#.###.
..#.....##
.#.##.....

Tile 2683:
.####.....
#..##.#..#
...#......
#.#.#..#.#
...#......
.#...##.#.
#.#..#....
#.##.....#
#..#......
.###...#..

Tile 1039:
#..##..###
....#.....
...##.#..#
..#..#...#
#..#..#.#.
#..###.#.#
#.#......#
#.....#..#
#####....#
.#.##....#

Tile 3907:
#..###.###
#.#..#....
.#......##
#......#.#
#.#..#..#.
...#......
#....#.#..
.....#...#
.#....#..#
#.#......#

Tile 3163:
#.##.###..
#..#...#..
..#...#.#.
.........#
...#.#.#..
..#.#.....
#.##...#..
#..#....##
...#.#...#
#..#.#####

Tile 1213:
#..##.#..#
###.....##
#.#...#.#.
###...####
#.##.##...
..#....#..
#..#......
.####.###.
#..#..###.
#..##..###

Tile 2389:
...##.###.
#........#
#.....#..#
.#......#.
.#.......#
.###.#..#.
#.#..#...#
..#.#....#
.......#.#
#..#..#.#.

Tile 3637:
..###.#.##
.#....##..
...#.##...
#...#....#
##........
........##
#..#......
.#..###...
##..#....#
##.#..#..#

Tile 3677:
##..###.##
#.....###.
.###......
#..#..#..#
.......##.
.....#...#
.##.....##
.#......##
....#...##
###..#....

Tile 2347:
.###.##.#.
#.##.#.#..
..##.....#
#..#.#....
#.#.#...##
##...##.##
#.........
#.#....#.#
##......##
###.#.##..

Tile 3469:
#.#.###.#.
#....#....
#......#..
...#..#..#
##..#.....
.....#...#
##..#.##.#
##........
.#.....##.
..#...#...

Tile 2887:
#..#....##
..#..#..#.
.#.....#..
.#.....#..
#..#....##
.#..#...#.
#...##.#.#
#..###...#
.##..#...#
.#.#...#.#

Tile 3331:
.#....###.
#......##.
...##.....
#.#.#.####
#.#.#.....
#....##..#
...#....##
...##.#.#.
.#..####.#
.#.#.#.##.

Tile 1901:
##..#.#..#
##.......#
#.#....#..
..#.#.....
##....#...
#....#.#.#
..##....#.
.....#.###
##.......#
..##..#.#.

Tile 1009:
##.#...##.
..........
#..#..#..#
.##.##...#
##.#......
##.##.##.#
..#......#
#.#.##....
##.#....##
######.#.#

Tile 2423:
#.##...#.#
....#.....
..#...#...
#..#.#...#
..#....#.#
..##..#.##
#.#.....##
#.........
#..#.#.###
#.#..####.

Tile 2029:
#...#.####
.........#
####..#..#
##.......#
#....##...
###.#.#.##
###...#...
.#.....#..
....#..###
##........

Tile 3767:
.##..#.#.#
..#..##.##
.....#...#
...##.#.##
#...#...##
#..#.####.
##.#..##..
#....#..##
..........
....#...#.

Tile 1223:
.#....#.#.
.#..####..
.##..#..##
..#....#.#
.#.#...#.#
..#...#.#.
#.#.....#.
.#.#.....#
#.....#.#.
..#..#.###

Tile 1583:
..#..###..
#.#.#...#.
#.#....#..
.....#....
..#......#
#...#.##..
#.#...#...
..##.....#
...##....#
##.###....

Tile 3181:
##...####.
.....##...
..##..#..#
...#....#.
###.#..#.#
...#...#.#
.#.####..#
#..##....#
#.###....#
#.#.##.##.

Tile 1181:
.##.######
#.........
#..##....#
#........#
##.#.....#
.....#....
#...##...#
#..##..#..
#..##.....
...##..##.

Tile 2749:
...##.####
#.#...##..
.#.###...#
##..#...#.
......##..
...##...#.
...###.#.#
.#.##..#.#
##.#.##.#.
.....#....

Tile 1579:
###..#..#.
#.#.......
...#.....#
...#.##..#
#.#.#.#.#.
...#.#..##
#.####..#.
#.#...#..#
..#.......
.#####.#..

Tile 2777:
##...###..
#......##.
...#......
.........#
#...#.....
.###.#..##
..#..#...#
...#...#..
#........#
###..#.###

Tile 3049:
#.#####...
.#...##...
#..#....##
........#.
####.....#
.#.....##.
#.#.....##
..#......#
..#.......
#...#....#

Tile 1657:
..#...##..
##....#...
....#..##.
#.#......#
##........
#...#..#.#
..#....#.#
..#..#.#..
##........
#####.####

Tile 1483:
#.....##.#
#.#....##.
#........#
#...#.##.#
.##.#.....
...#.....#
#.....#...
......#...
..###....#
..##.###.#

Tile 1367:
###.###..#
###..#.#.#
..........
##.###....
....###..#
#.#..#...#
#..#.....#
..#......#
#.##..#...
#....#...#

Tile 3061:
.#.##..#.#
..#..#....
.#..#.#...
.#.....###
##...#...#
..#...#..#
#.#..#....
#.#..#..#.
......#...
##.##.#.##

Tile 1487:
..###.##.#
#....#.###
#......#..
..#.#.###.
..........
..#...#..#
....#.#.##
#.###..##.
...#..###.
#.....##.#

Tile 1693:
...#...##.
...##....#
..#.#.#..#
#..#......
#.....#..#
..#....#..
.#........
#..#.#....
..........
..#.#..##.

Tile 3671:
....#.##..
.#.......#
#.#......#
#.#.......
#.......#.
#......###
#.#....#..
........#.
.....##..#
.##.#..#..

Tile 3169:
.#.#####.#
..#...#...
#........#
.#..#....#
######.#..
#.#####...
.......##.
.#...#....
#..#.....#
#.#####.##

Tile 1061:
###...####
...#.#..#.
#......#.#
#.#..#..#.
#......#..
...#...###
...#......
...#......
#.#....#.#
.#..##.#.#

Tile 2477:
...#..##..
#....#...#
#..#...#.#
##...###.#
..#....##.
......##.#
#........#
##.#..#.##
......##..
#.####..#.

Tile 1783:
###....##.
#..#..#.##
#...#.#.#.
##.#..#...
#.##...#..
##.......#
...##....#
....#....#
##.#.##..#
###.......

Tile 2713:
##..###...
#..#....##
.........#
###.....#.
.###.##.#.
#..##.#...
##..##.#.#
##..##..#.
.......#..
##.#..###.

Tile 1097:
#..#.#...#
...##.....
#..#.....#
#...##...#
#........#
##.......#
....#....#
#.#..##..#
..#...##.#
####.####.

Tile 1861:
##.##.###.
.##...#...
.#...#...#
.#.#......
..#..#.#.#
#.#..##..#
......###.
..#....##.
.#..#.#...
....#..#..

Tile 2069:
##.######.
...#...###
.#.......#
.#..#.....
......###.
..##.##...
....###...
#....#...#
.#....#...
...#....##

Tile 2657:
.#..###...
#..#...#..
##...#...#
..........
##.##.....
#.......#.
.....#..#.
..#.......
##..#.....
###.##...#

Tile 3527:
...###..#.
#....#..##
##....#.##
...#..####
...#...###
#.........
#....#...#
#..#......
......#.#.
......###.

Tile 2927:
...###.##.
....##...#
.......##.
#####.....
#...#...##
.....#...#
.#...###.#
.#...#....
#..#.#.#.#
#.##.##.#.