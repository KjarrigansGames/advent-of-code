def game(player_1, player_2, recursive: false)
  memory = []
  until player_1.empty? || player_2.empty?
    turn(player_1, player_2, recursive: recursive)
    turnid = [player_1.join('-'), player_2.join('-')].join('|')
    if memory.include?(turnid)
#       puts "Endlessloop detected! p1 wins!"
      return [:p1, 0]
    end
    memory << turnid
  end

  winner = player_1
  winner = player_2 if player_1.empty?

  score = winner.reverse.map.with_index(1) do |val, idx|
    idx * val
  end.sum

  [player_1.empty? ? :p2 : :p1, score]
end

def turn(p1, p2, recursive: false)
  a = p1.shift
  b = p2.shift

  winner = if recursive && (p1.size >= a && p2.size >= b)
#     p "Subgame initiated... #{a} #{p1.clone[0, a]} | #{b} #{p2.clone[0, b]}"
    winner, _score = game(p1.clone[0, a], p2.clone[0, b], recursive: recursive)
#     p "Subgame won by #{winner}"
    winner
  end

  if (winner.nil? && a > b) || winner == :p1
    p1 << a
    p1 << b
  else
    p2 << b
    p2 << a
  end
end

player_1 = %w[38 39 42 17 13 37 4 10 2 34 43 41 22 24 46 19 30 50 6 44 28 27 36 5 45].map(&:to_i)
player_2 = %w[31 40 25 11 3 48 16 9 33 7 12 35 49 32 26 47 14 8 20 23 1 29 15 21 18].map(&:to_i)
# recursive sample:
# player_1 = [9, 2, 6, 3, 1]
# player_2 = [5, 8, 4, 7, 10]

printf "Part 1 - %s won with %s points\n", *game(player_1.clone, player_2.clone)
p1, p2 = player_1.clone, player_2.clone
printf "Part 2 - %s won with %s points\n", *game(p1, p2, recursive: true)
# 32862 is too low
# binding.irb
