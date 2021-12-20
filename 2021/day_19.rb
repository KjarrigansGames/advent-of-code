require 'matrix'

class Beacon < Vector
  def mirror(axis_vector)
    Beacon[
      self[0] * axis_vector[0],
      self[1] * axis_vector[1],
      self[2] * axis_vector[2]
    ]
  end
  
  def x; self[0]; end
  def xn; -self[0]; end
  def y; self[1]; end
  def yn; -self[1]; end
  def z; self[2]; end
  def zn; -self[2]; end
    
  VARIATIONS = [%w[x y z], %w[xn y z], %w[x yn z], %w[x y zn], %w[xn yn z], %w[xn y zn], %w[x yn zn], %w[xn yn zn]].map { _1.permutation.to_a }.flatten(1).uniq
  ROTATION = {
    # z-Rotation
    z: [
         #  y,-x, z
         Vector[2,-1, 3],
         # -x,-y, z
         Vector[-1,-2,3],
         # -y, x, z
         Vector[-2,1,3],
       ],
    # y-Rotation
    y: [
         #  z, y,-x
         Vector[3,2,-1],
         # -x, y,-z
         Vector[-1,2,-3],
         # -z, y, x
         Vector[-1,2,-3],
       ],
    # x-Roation
    x: [
         #  x,-z, y
        Vector[1,-3,2],
         #  x,-y,-z
        Vector[1,-2,-3],
         #  x, z,-y
        Vector[1,3,-2]
       ]
  }
  def rotate(transform)
    Beacon[*transform.map { |t| self.send(t) }]
  end
end

Scanner = Struct.new :num, :beacons, :absolute_beacons do
  attr_accessor :pos, :rotation
  
  # Def
  #  5, 6,-4  x  y  z
  #  8, 0, 7  x  y  z
  # 
  # -5, 4,-6 -x -z -y
  # -8,-7, 0 -x -z -y
  # 
  #  4, 6, 5 -z  y  x
  # -7, 0, 8 -z  y  x
  # 
  # -4,-6, 5  z -y  x
  #  7, 0, 8  z -y  x
  # 
  # -6,-4,-5 -y  z -x
  #  0, 7,-8 -y  z -x
  
  # In total, each scanner could be in any of 24 different orientations: facing 
  # positive or negative x, y, or z, and considering any of four directions "up" 
  # from that facing.  ????
  # -> in theory there are 48 combinations of [x,y,z,-x,-y,-z]
  # so which are considered "invalid"...
  DIRECTIONS = {
    Vector[ 1, 1, 1] => :mirror, # Default
    Vector[-1, 1, 1] => :mirror, # x Mirror
    Vector[ 1,-1, 1] => :mirror, # y Mirror
    Vector[ 1, 1,-1] => :mirror, # z Mirror
    
    Vector[-1,-1, 1] => :mirror, # xy Mirror
    Vector[-1, 1,-1] => :mirror, # xz Mirror
    Vector[ 1,-1,-1] => :mirror, # yz Mirror
    
    Vector[0, 1] => :swap, # xy-Swap
  }
  
  def to_s
    format "Scanner#%2d @ (%5d,%5d,%5d) | %s", num, pos.x, pos.y, pos.z, rotation
  end
  
  def triangulate(other)
    Beacon::VARIATIONS.each do |var|
      coords = Hash.new(0)
      beacons.each do |a|
        other.beacons.each do |b|
          b_rot = Beacon[b.send(var[0]),b.send(var[1]),b.send(var[2])]
          # coords[a + b.send(transform_method, axis)] += 1
          coords[a + b_rot] += 1
        end
      end
      if coords.values.max >= 12
        puts "Found a valid position between ##{self.num} and ##{other.num}"
        puts other
        pos, _ = coords.find { |pos, val| val == coords.values.max }
        
        p var
        p pos
        pos = Beacon[*other.rotation.map { |val| pos.send(val) }]
        pos = Beacon[*var.map { |val| pos.send(val) }]
        self.pos = other.pos + pos
        self.rotation = var
        self.beacons.each do |b|
          b = Beacon[*other.rotation.map { |val| b.send(val) }]          
          b = Beacon[*self.rotation.map { |val| b.send(val) }]          
          self.absolute_beacons << self.pos - b
        end
        
        puts pos
        puts other
                
        return coords.values.max
      end
    end
    
    false
  end
end
#  Scanner 0       Scanner 1 @ 68,-1246,-43
# 
#  404,-588,-901 | -336, 658, 858 <-- 4   68
#  528,-643, 409     95, 138,  22 
# -838, 591, 734   -322, 571, 750
#  390,-675,-793    669,-402, 600
# -537,-823,-458 |  605, 423, 415 <-- 2    68, -400, -43
# -485,-357, 347   -429,-592, 574
# -345,-311, 381   -340,-569,-846
# -661,-816,-575    567,-361, 727
# -876, 649, 763   -460, 603,-452
# -618,-824,-621 |  686, 422, 578 <-- 1    68, -402, -43
#  553, 345,-567    729, 430, 532
#  474, 580, 667   -500,-761, 534
# -447,-329, 318 |  515, 917,-361 <-- 3
# -584, 868,-557   -466,-666,-811
#  544,-627,-890 | -476, 619, 847 <-- 5
#  564, 392,-477   -355, 545,-477
#  455, 729, 728    703,-491,-529
# -892, 524, 684   -328,-685, 520
# -689, 845,-530    413, 935,-424
#  423,-701, 434   -391, 539,-444
#    7,- 33,- 71    586,-435, 557
#  630, 319,-379   -364,-763,-893
#  443, 580, 662    807,-499,-711
# -789, 900,-551    755,-354,-619
#  459,-707, 401    553, 889,-390

# The sample shows that A + B' = Z reveals that there are identical 12 values, so use A as is
# and sum up all possible combinations of Vectors (Beacons) from B times 24 (because there are 24
# different directions it could face).

def parse_input(input)
  scanner = []
  
  current = nil 
  input.each do |line|
    case line
    when /--- scanner (\d+) ---/
      current = Scanner.new($1, [], [])
    when /([-0-9]+),([-0-9]+),([-0-9]+)/
      current.beacons << Beacon[$1.to_i, $2.to_i, $3.to_i]
    when /\n/
      scanner << current
    else
      raise "Invalid input #{line.inspect}"
    end
  end
  scanner << current
  scanner
end

def part1(input)
  scanner = parse_input(input)
  scanner[0].pos = Beacon[0,0,0]
  scanner[0].rotation = [:x, :y, :z]
  scanner[0].absolute_beacons = scanner[0].beacons
  done = [ scanner.shift ]

  until scanner.empty?
    done.each do |ref|
      scanner.reject! do |cur|
        success = cur.triangulate(ref)
        if success
          done << cur
          next true
        end
        false
      end
    end
  end
  
  puts "=" * 30
  done.sort_by(&:num).each { puts _1 }
  
  p done.sum { _1.beacons.size }
  done.map { _1.absolute_beacons }.flatten.uniq.size
end

print "Sample 79 == "
puts part1(DATA.readlines)

# Part 1: 479 is too high (but someone elses)

__END__
--- scanner 0 ---
404,-588,-901
528,-643,409
-838,591,734
390,-675,-793
-537,-823,-458
-485,-357,347
-345,-311,381
-661,-816,-575
-876,649,763
-618,-824,-621
553,345,-567
474,580,667
-447,-329,318
-584,868,-557
544,-627,-890
564,392,-477
455,729,728
-892,524,684
-689,845,-530
423,-701,434
7,-33,-71
630,319,-379
443,580,662
-789,900,-551
459,-707,401

--- scanner 1 ---
686,422,578
605,423,415
515,917,-361
-336,658,858
95,138,22
-476,619,847
-340,-569,-846
567,-361,727
-460,603,-452
669,-402,600
729,430,532
-500,-761,534
-322,571,750
-466,-666,-811
-429,-592,574
-355,545,-477
703,-491,-529
-328,-685,520
413,935,-424
-391,539,-444
586,-435,557
-364,-763,-893
807,-499,-711
755,-354,-619
553,889,-390

--- scanner 2 ---
649,640,665
682,-795,504
-784,533,-524
-644,584,-595
-588,-843,648
-30,6,44
-674,560,763
500,723,-460
609,671,-379
-555,-800,653
-675,-892,-343
697,-426,-610
578,704,681
493,664,-388
-671,-858,530
-667,343,800
571,-461,-707
-138,-166,112
-889,563,-600
646,-828,498
640,759,510
-630,509,768
-681,-892,-333
673,-379,-804
-742,-814,-386
577,-820,562

--- scanner 3 ---
-589,542,597
605,-692,669
-500,565,-823
-660,373,557
-458,-679,-417
-488,449,543
-626,468,-788
338,-750,-386
528,-832,-391
562,-778,733
-938,-730,414
543,643,-506
-524,371,-870
407,773,750
-104,29,83
378,-903,-323
-778,-728,485
426,699,580
-438,-605,-362
-469,-447,-387
509,732,623
647,635,-688
-868,-804,481
614,-800,639
595,780,-596

--- scanner 4 ---
727,592,562
-293,-554,779
441,611,-461
-714,465,-776
-743,427,-804
-660,-479,-426
832,-632,460
927,-485,-438
408,393,-506
466,436,-512
110,16,151
-258,-428,682
-393,719,612
-211,-452,876
808,-476,-593
-575,615,604
-485,667,467
-680,325,-822
-627,-443,-432
872,-547,-609
833,512,582
807,604,487
839,-516,451
891,-625,532
-652,-548,-490
30,-46,-14
