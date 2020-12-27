@cards = (0..10006).to_a

def deal_into_new_stack
  @cards.reverse!
end

def cut(qty)
  if qty.negative?
    @cards.unshift(@cards.slice!(qty, qty.abs)).flatten!
  else
    @cards += @cards.slice!(0, qty)
  end
end

def deal_with_increment(offset)
  pos = 0
  new_stack = []

  @cards.each do |card|
    new_stack[pos] = card
    pos = (pos + offset) % @cards.size
  end
  @cards = new_stack
end

# @cards = (0..9).to_a
#
# deal_with_increment 7
# deal_with_increment 9
# cut -2
# p @cards
# exit

DATA.readlines.each do |line|
  eval line.chomp
end

p @cards.index(2019)
binding.irb

__END__
cut 3334
deal_into_new_stack
deal_with_increment 4
cut -342
deal_with_increment 30
cut -980
deal_into_new_stack
cut -8829
deal_with_increment 10
cut -7351
deal_with_increment 60
cut -3766
deal_with_increment 52
cut 8530
deal_with_increment 35
cut -6979
deal_with_increment 52
cut -8287
deal_with_increment 34
cut -6400
deal_with_increment 24
deal_into_new_stack
deal_with_increment 28
cut 7385
deal_with_increment 32
cut -1655
deal_with_increment 66
cut -2235
deal_with_increment 40
cut 8121
deal_with_increment 71
cut -2061
deal_with_increment 73
cut 7267
deal_with_increment 19
cut 2821
deal_with_increment 16
cut 7143
deal_into_new_stack
deal_with_increment 31
cut 695
deal_with_increment 26
cut 9140
deal_with_increment 73
cut -4459
deal_with_increment 17
cut 9476
deal_with_increment 70
cut -9832
deal_with_increment 46
deal_into_new_stack
deal_with_increment 62
cut 6490
deal_with_increment 29
cut 3276
deal_into_new_stack
cut 6212
deal_with_increment 9
cut -2826
deal_into_new_stack
cut -1018
deal_into_new_stack
cut -9257
deal_with_increment 39
cut 4023
deal_with_increment 69
cut -8818
deal_with_increment 74
cut -373
deal_with_increment 51
cut 3274
deal_with_increment 38
cut 1940
deal_into_new_stack
cut -3921
deal_with_increment 3
cut -8033
deal_with_increment 38
cut 6568
deal_into_new_stack
deal_with_increment 68
deal_into_new_stack
deal_with_increment 70
cut -9
deal_with_increment 32
cut -9688
deal_with_increment 4
deal_into_new_stack
cut -1197
deal_with_increment 54
cut -582
deal_into_new_stack
cut -404
deal_into_new_stack
cut -8556
deal_with_increment 47
cut 7318
deal_with_increment 38
cut -8758
deal_with_increment 48
