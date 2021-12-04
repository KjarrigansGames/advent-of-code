class Board
  property data_in_rows = [] of Array(Int32)
  property data_in_cols = [] of Array(Int32)

  def initialize(@data_in_rows)
    @data_in_cols = @data_in_rows.map_with_index do |row, y|
      row.map_with_index do |num, x|
        @data_in_rows[x][y]
      end
    end
  end

  def self.parse(blob)
    blob = blob.split("\n").map do |row|
      row.scan(/(\d+)/).map { |md| md[1].to_i32 }
    end
    new(blob)
  end

  def solved?(marked_numbers : Array(Int32))
    @data_in_rows.each do |row|
      return true if (row - marked_numbers).empty?
    end
    @data_in_cols.each do |col|
      return true if (col - marked_numbers).empty?
    end

    false
  end

  def score(marked_numbers : Array(Int32))
    (@data_in_cols.flatten - marked_numbers).sum * marked_numbers[-1]
  end
end

SAMPLE = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7"

def bingo(input, first_winner = true)
  boards = [] of Board
  data = input.split("\n\n")
  rng = data.shift.split(",").map { |num| num.to_i32 }
  boards = data.map { |blob| Board.parse(blob) }
  last_winner = 0
  rng.size.times do |round|
    boards.each do |bo|
      next unless  bo.solved?(rng[0..round])
      if first_winner
        return bo.score(rng[0..round])
      else
        return boards.first.score(rng[0..round]) if boards.size == 1
        boards.delete(bo)
      end
    end
  end
end

print "Sample 4512 == "
puts bingo(SAMPLE)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts bingo(input)

print "Sample 1924 == "
puts bingo(SAMPLE, first_winner: false)

print "Part 2: "
puts bingo(input, first_winner: false)
