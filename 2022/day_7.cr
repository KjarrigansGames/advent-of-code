class AocFile
  property name : String
  property size : Int64

  def initialize(@name, @size); end
end

class AocDirectory
  property name : String
  property parent : AocDirectory|Nil
  property files = Array(AocFile).new
  property dirs = Array(AocDirectory).new

  def initialize(@name, @parent); end
  def size : Int64
    dirs.map { |d| d.size }.sum +
    files.map { |f| f.size }.sum
  end
end

def generate_fs_tree(input)
  root = AocDirectory.new("root", nil)
  current_dir : AocDirectory = root

  input.each do |line|
    case line
    when /^\$ cd \// then current_dir = root
    when /^\$ cd \.\./
      parent = current_dir.parent
      raise "Already in root" if parent.nil?

      current_dir = current_dir.parent.not_nil!
    when /^\$ cd (.*)/
      next_dir = current_dir.dirs.find { |d| d.name == $1 } # it already exists
      if next_dir.nil?
        next_dir = AocDirectory.new($1, current_dir)
        current_dir.dirs << next_dir
      end
      current_dir = next_dir
    when /^dir/ then next # ignore
    when /^\$ ls/ then next # ignore
    when /(\d+) (.*)/
      current_dir.files << AocFile.new($2, $1.to_i)
    else
      puts "Skipping: #{line}"
    end
  end
  root
end

def print_tree(root, level = 0)
  print "  " * level
  puts root.name
  root.dirs.each do |d|
    print_tree(d, level + 1)
  end

  root.files.each do |f|
    print "  " * level
    printf "%-10d %s", f.size, f.name
    puts
  end
end

def part1(root)
  list = [] of AocDirectory

  root.dirs.each do |dir|
    list << dir if dir.size < 100_000
    list += part1(dir)
  end

  list
end

DRIVE_SIZE = 70_000_000
NECESSARY_SPACE = 30_000_000

def search(root, size)
  list = [] of AocDirectory

  root.dirs.each do |dir|
    list << dir if dir.size >= size
    list += search(dir, size)
  end
  list
end

def part2(root)
  to_delete : Int32 = NECESSARY_SPACE - (DRIVE_SIZE - root.size)

  search(root, to_delete).map { |d| d.size }.min
end

TEST = (<<-EOF).split("\n").map { |line| line.strip }
  $ cd /
  $ ls
  dir a
  14848514 b.txt
  8504156 c.dat
  dir d
  $ cd a
  $ ls
  dir e
  29116 f
  2557 g
  62596 h.lst
  $ cd e
  $ ls
  584 i
  $ cd ..
  $ cd ..
  $ cd d
  $ ls
  4060174 j
  8033020 d.log
  5626152 d.ext
  7214296 k
EOF

spec = generate_fs_tree(TEST)
print "Test Part 1: 95437 =="
p part1(spec).map { |d| d.size }.sum

print "Part 1: "
input = generate_fs_tree(File.read_lines("day_7.txt"))
puts part1(input).map { |d| d.size }.sum

print "Test Part 2: 24933642 =="
p part2(spec)

print "Part 2: "
p part2(input)
