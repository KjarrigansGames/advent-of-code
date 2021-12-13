SAMPLE = "start-A
start-b
A-c
A-b
b-d
A-end
b-end"

SAMPLE2 = "dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc"

def setup_map(input)
  tree = Tree.new
  input.split("\n").each do |line|
    start, stop = line.split("-")
    tree[start] ||= [] of String
    tree[start] << stop

    tree[stop] ||= [] of String
    tree[stop] << start
  end
  tree
end

def large_cavern?(cav)
  cav.upcase == cav
end

def only_small_cave?(path)
  path.select { |node| node.downcase == node }.tally.values.all? { |occurance| occurance == 1 }
end

alias Tree = Hash(String, Array(String))
def find_paths(tree : Tree, current_path : Array(String), small_caves=false)
  valid_paths = [] of Array(String)

  tree[current_path.last].each do |destination|
    next if destination == "start"

    # puts "Checking... #{destination}"
    if destination == "end"
      valid_paths << (current_path + [destination])
      # puts "end reached -> #{current_path.join(',')}"
      next
    end

    if current_path.includes?(destination)
      if large_cavern?(destination)
        # puts "Go back to large cavern #{destination}"
        valid_paths += find_paths(tree, current_path + [destination], small_caves: small_caves)
      elsif small_caves && only_small_cave?(current_path)
        valid_paths += find_paths(tree, current_path + [destination], small_caves: false)
      else
        # puts "Dead End"
        next
      end
    end

    valid_paths += find_paths(tree, current_path + [destination], small_caves: small_caves)
  end

  valid_paths
end

def pathfinder(input, small_caves=false)
  tree = setup_map(input)

  paths = find_paths(tree, ["start"], small_caves: small_caves)
  paths = paths.map { |ph| ph.join(",") }.uniq
  # puts paths.sort.join("\n")
  paths.size
end

print "Sample 10 == "
puts pathfinder(SAMPLE)

print "Sample 19 == "
puts pathfinder(SAMPLE2)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts pathfinder(input)

print "Sample 36 == "
puts pathfinder(SAMPLE, small_caves: true)

print "Sample 103 == "
puts pathfinder(SAMPLE2, small_caves: true)

print "Part 2: "
puts pathfinder(input, small_caves: true)
