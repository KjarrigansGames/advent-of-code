SAMPLE = "3,4,3,1,2"

def grow(list)
  new_fish = [] of Int32
  list = list.map do |val|
    val = val - 1
    if val < 0
      new_fish << 8
      next 6
    end
    val
  end

  list + new_fish
end

def lanternfish(input, days)
  list = input.split(",").map { |val| val.to_i64 }
  days.times { list = grow(list) }
  list.size
end


EMPTY_ACCOUNT = { 0 => 0i64, 1 => 0i64, 2 => 0i64, 3 => 0i64, 4 => 0i64, 5 => 0i64, 6 => 0i64, 7 => 0i64, 8 => 0i64}
def lanternfish_fast(input, days)
  book = EMPTY_ACCOUNT.dup
  list = input.split(",").each do |val|
    book[val.to_i32] += 1
  end

  days.times do
    new_book = EMPTY_ACCOUNT.dup
    book.each do |day, num|
      day -= 1
      if day < 0
        day = 6
        new_book[8] = num
      end
      new_book[day] += num
    end
    book = new_book
  end
  book.values.sum
end

print "Sample 26 == "
puts lanternfish_fast(SAMPLE, days: 18)

print "Sample 5934 == "
puts lanternfish_fast(SAMPLE, days: 80)

input = "2,1,2,1,5,1,5,1,2,2,1,1,5,1,4,4,4,3,1,2,2,3,4,1,1,5,1,1,4,2,5,5,5,1,1,4,5,4,1,1,4,2,1,4,1,2,2,5,1,1,5,1,1,3,4,4,1,2,3,1,5,5,4,1,4,1,2,1,5,1,1,1,3,4,1,1,5,1,5,1,1,5,1,1,4,3,2,4,1,4,1,5,3,3,1,5,1,3,1,1,4,1,4,5,2,3,1,1,1,1,3,1,2,1,5,1,1,5,1,1,1,1,4,1,4,3,1,5,1,1,5,4,4,2,1,4,5,1,1,3,3,1,1,4,2,5,5,2,4,1,4,5,4,5,3,1,4,1,5,2,4,5,3,1,3,2,4,5,4,4,1,5,1,5,1,2,2,1,4,1,1,4,2,2,2,4,1,1,5,3,1,1,5,4,4,1,5,1,3,1,3,2,2,1,1,4,1,4,1,2,2,1,1,3,5,1,2,1,3,1,4,5,1,3,4,1,1,1,1,4,3,3,4,5,1,1,1,1,1,2,4,5,3,4,2,1,1,1,3,3,1,4,1,1,4,2,1,5,1,1,2,3,4,2,5,1,1,1,5,1,1,4,1,2,4,1,1,2,4,3,4,2,3,1,1,2,1,5,4,2,3,5,1,2,3,1,2,2,1,4"
print "Part 1: "
puts lanternfish_fast(input, days: 80)

print "Part 2: "
puts lanternfish_fast(input, days: 256)
