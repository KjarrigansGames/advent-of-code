def transform(loop_size, subject=7)
  value : Int64 = 1

  loop_size.times do
    value = (value * subject) % 20201227
  end

  value
end

def loop_size(card, door)
  (1...).each do |trial|
    s = transform(trial)
    return [trial, door] if s == card
    return [trial, card] if s == door
  end
end

def encryption_key(card, door)
  loop_size, other_key = loop_size(card, door)
  transform(loop_size, other_key)
end

# sample data
pub_card = 5764801
pub_door = 17807724
raise "Calculation wrong!" unless encryption_key(pub_card, pub_door) == 14897079

pub_card = 13316116
pub_door = 13651422

key = encryption_key(pub_card, pub_door)
print "Part 1: "
puts key
