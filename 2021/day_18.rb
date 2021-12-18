def deep_clone(ary)
  Marshal.load(Marshal.dump(ary))
end

def increment_next_num(num, idx, val)
  if num[idx].is_a?(Integer)
    num[idx] += val
  else
    num[idx] = increment_next_num(num[idx], idx, val)
  end
  num
end

def try_explosion(num, level=1)
  # Try explosion
  if num[0].is_a?(Array)
    # Exploding pairs will always consist of two regular numbers. 
    if level >= 4 && num[0].flatten.size == 2
      if num[1].is_a?(Integer)
        num[1] += num[0][1]
      else
        increment_next_num(num[1], 0, num[0][1])
      end
      exp = num[0][0]
      num[0] = 0
      
      return [ { left: exp }, num]
    else 
      # I'm the left part and if an explosion to the left occurs
      # I can't do anything and have to delegate it to the upper level
      # BUT if a right explosion happened I have to increment my right partner
      exploded, num[0] = try_explosion(num[0], level+1)
      if exploded
        if exploded[:right]
          if num[1].is_a?(Integer)
            num[1] += exploded[:right]
          else
            increment_next_num(num[1], 0, exploded[:right])
          end         
          return [{}, num]
        elsif exploded[:left]
          return [exploded, num] 
        else
          return [{}, num]
        end
      end
    end
  end
  
  if num[1].is_a?(Array)
    if level >= 4 && num[1].flatten.size == 2
      if num[0].is_a?(Integer)
        num[0] += num[1][0]
      else
        increment_next_num(num[0], 1, num[1][0])
      end
      exp = num[1][1]
      num[1] = 0
      
      return [ { right: exp }, num]
    else
      # Same as above. As the "right" partner I can't explode so just pass through otherwise
      # increment my left partner
      exploded, num[1] = try_explosion(num[1], level+1)
      if exploded
        if exploded[:left]
          if num[0].is_a?(Integer)
            num[0] += exploded[:left]
          else
            increment_next_num(num[0], 1, exploded[:left])
          end         
          return [{}, num]
        elsif exploded[:right]
          return [exploded, num] 
        else
          return [{}, num]
        end
      end
    end
  end

  return [false, num]
end

def try_split(num)
  spl = false
  if num.is_a?(Integer)
    return [false, num] if num < 10    
  end
    
  if num[0].is_a?(Array)
    spl, num[0] = try_split(num[0])
    return spl, num if spl
  else
    if num[0] >=  10
      # puts "Split: #{num.inspect}"
      num[0] = [(num[0] / 2.0).floor, (num[0] / 2.0).ceil]
      return [true, num]
    end
  end
  
  if num[1].is_a?(Array)
    spl, num[1] = try_split(num[1])
    return spl, num if spl
  else
    if num[1] >=  10
      # puts "Split: #{num.inspect}"
      num[1] = [(num[1] / 2.0).floor, (num[1] / 2.0).ceil]
      return [true, num]
    end    
  end
  
  [spl, num]
end

def snail_reduce(num)
  loop do
    exp, num = try_explosion(num)
    next if exp
    
    spl, num = try_split(num)
    next if spl
    
    break
  end
  
  num
end

def magnitude(num)
  a = num[0].is_a?(Array) ? magnitude(num[0]) : num[0]
  b = num[1].is_a?(Array) ? magnitude(num[1]) : num[1]
  (a*3) + (b*2)
end

def part1(input)
  current = snail_reduce(input[0])
  
  input[1..-1].each do |num|
    current = snail_reduce([current, snail_reduce(num)])
  end
  
  magnitude(current)
end

def part2(input)
  rank = {}
  input.combination(2).each do |a,b|
    rank[[a,b]] = part1(deep_clone([a,b]))
    rank[[b,a]] = part1(deep_clone([b,a]))
  end
  rank.find { _2 == rank.values.max }
end

# puts "## Reduce"
# print "Sample [[[[0, 9], 2], 3], 4] == "
# p snail_reduce([[[[[9,8],1],2],3],4])
# 
# print "Sample [7, [6, [5, [7, 0]]]] == "
# p snail_reduce([7,[6,[5,[4,[3,2]]]]])
# 
# print "Sample [[6, [5, [7, 0]]], 3] == "
# p snail_reduce([[6,[5,[4,[3,2]]]],1])
# 
# print "Sample [[3, [2, [8, 0]]], [9, [5, [7, 0]]]] == "
# p snail_reduce([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])
# 
# print "Sample [[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]] == "
# p snail_reduce([[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]])

# puts
# puts "## Magnitude"
# {
#   [[1,2],[[3,4],5]] => 143,
#   [[[[0,7],4],[[7,8],[6,0]]],[8,1]] => 1384,
#   [[[[1,1],[2,2]],[3,3]],[4,4]] => 445,
#   [[[[3,0],[5,3]],[4,4]],[5,5]] => 791,
#   [[[[5,0],[7,4]],[5,5]],[6,6]] => 1137,
#   [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]] => 3488,
#   [[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]] => 4140
# }.each do |num, mag|
#   print "Sample #{mag} == "
#   puts magnitude(num)
# end
# 
# p part1([
#   [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],
#   [7,[[[3,7],[4,3]],[[6,3],[8,8]]]],
#   [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]],
#   [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]],
#   [7,[5,[[3,8],[1,4]]]],
#   [[2,[2,2]],[8,[8,1]]],
#   [2,9],
#   [1,[[[9,3],9],[[9,0],[0,7]]]],
#   [[[5,[7,4]],7],1],
#   [[[[4,2],2],6],[8,7]],
# ])

# IS: [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[6,0],[6,7]]]]
# EX: [[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]

# [[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]
# print "Sample 3488 == "
# puts part1([
#   [[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]],
#   [7,[[[3,7],[4,3]],[[6,3],[8,8]]]],
#   [[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]],
#   [[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]],
#   [7,[5,[[3,8],[1,4]]]],
#   [[2,[2,2]],[8,[8,1]]],
#   [2,9],
#   [1,[[[9,3],9],[[9,0],[0,7]]]],
#   [[[5,[7,4]],7],1],
#   [[[[4,2],2],6],[8,7]],
# ])  
# 
# input = File.readlines(File.expand_path('../day_18.txt', __FILE__)).map { eval _1 }
# print "Part 1: "
# puts part1(input)
# 
# print "Sample 3993 == "
# p part2([
#   [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]],
#   [[[5,[2,8]],4],[5,[[9,9],0]]],
#   [6,[[[6,2],[5,6]],[[7,6],[4,7]]]],
#   [[[6,[0,7]],[0,9]],[4,[9,[9,0]]]],
#   [[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]],
#   [[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]],
#   [[[[5,4],[7,7]],8],[[8,3],8]],
#   [[9,3],[[9,9],[6,[4,9]]]],
#   [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]],
#   [[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]],
# ])
# 
# p snail_reduce([
#   [[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]], [[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]
# ])

print "Part 2: "
input = File.readlines(File.expand_path('../day_18.txt', __FILE__)).map { eval _1 }
p part2(input)
# 3123 too low
# 5491 too high

# [[[[1,8],[7,6]],[[8,6],[3,2]]],[[[0,5],[[7,7],5]],[[[2,7],[6,0]],[[7,9],[2,2]]]]]

# [[[[1,8],[7,6]],[[8,6],[3,2]]],[[[0,5],[[7,7],5]],[[[2,7],[6,0]],[[7,9],[2,2]]]]]
# [[[[1,8],[7,6]],[[8,6],[3,2]]],[[[0,12],[0,12]],[[[2,7],[6,0]],[[7,9],[2,2]]]]]

# [[[[1,8],[7,6]],[[8,6],[3,2]]],[[[0,[6,6]],[0,12]],[[[2,7],[6,0]],[[7,9],[2,2]]]]]
# [[[[1,8],[7,6]],[[8,6],[3,2]]],[[[6,0],[6,[6,6]]],[[[2,7],[6,0]],[[7,9],[2,2]]]]]
# [[[[1,8],[7,6]],[[8,6],[3,2]]],[[[6,0],[[6,6],0]],[[[8,7],[6,0]],[[7,9],[2,2]]]]]

# snail_reduce([[[[1,8],[7,6 ]],[[8,6],[3,2]]],[[[0,5],[[7,7],5]],[[[2,7],[6,0]],[[7,9],[2,2]]]]])
