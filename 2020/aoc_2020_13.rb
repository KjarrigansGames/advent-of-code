inp = DATA.readlines
# arrival = inp[0].chomp.to_f
bus_times = inp[1].chomp.split(',').map(&:to_i)

# def part_1(bus_times, arrival)
#   deltas = bus_times.to_h do |interval|
#     next [0, 0] if interval.zero?
#
#     [interval, ((arrival / interval).ceil * interval) - arrival]
#   end
#
#   print "Part 1: "
#   puts deltas.sort_by { _2 }[1].inject(&:*)
# end
#
# part_1 bus_times, arrival

targets = bus_times.map.with_index do |interval, offset|
  next nil if interval.to_i.zero?

  [interval, offset]
end.compact.sort
targets.delete(0)

x = -4
until x % 7 == 0 &&
      (x + 1) % 13 == 0 &&
      # (x + 4) % 59 == 0 &&
      (x + 6) % 31 == 0 &&
      (x + 7) % 19 == 0
  x += 59
end
p x
# exit

x = -17
until x % 17 == 0 &&
      (x + 48) % 397 == 0 &&
      (x + 36) % 19 == 0 &&
      (x + 40) % 23 == 0 &&
      (x + 19) % 29 == 0 &&
      (x + 54) % 37 == 0 &&
      (x + 7) % 41 == 0 &&
      (x + 61) % 13 == 0
  x += 983
end

p x

binding.irb

__END__
1000434
17,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,983,x,29,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19,x,x,x,23,x,x,x,x,x,x,x,397,x,x,x,x,x,37,x,x,x,x,x,x,13

1068781
7,13,x,x,59,x,31,19

