RULES = {}

class String
  def join
    self
  end
end

def parse_rules(line)
  no, policy = line.split(': ')
  rules = policy.split(' | ').map do |nums|
    nums.split(' ').map { eval _1 }
  end
  rules = rules.first if rules.size == 1
  rules = rules.first if rules.size == 1
  RULES[no.to_i] = rules
end

def replace_known_combinations(rule, seq)
  if seq.is_a?(Integer) && KNOWN[seq]
    RULES[rule][RULES[rule].index(seq)] = KNOWN[seq]
    return
  end
  seq.map! { KNOWN[_1] || _1 }
end

KNOWN = {}
def resolve_rules
  ra = RULES.key('a')
  KNOWN[ra] = RULES.delete(ra)
  rb = RULES.key('b')
  KNOWN[rb] = RULES.delete(rb)

  while RULES[0]
    RULES.each do |num, subs|
      next if subs.is_a?(Integer)
      next subs.each { replace_known_combinations(num, _1) } if subs.first.is_a?(Array)

      replace_known_combinations num, subs
    end

    RULES.delete_if do |num, subs|
      next KNOWN[num] = subs if subs.is_a?(Integer)
      next false if subs.flatten.join.match?(/\d/)

      if a=subs.find { _1.is_a?(Array) }
        if !a.find { _1.is_a?(Array) }
          KNOWN[num] = subs.map!(&:join)
        else
          KNOWN[num] = subs
        end
      else
        KNOWN[num] = subs.join
      end
      true
    end
  end

  KNOWN[0]
end

def special?(seq)
  seq.all?{ _1.is_a?(Array) } && seq.all? { _1.all?{|a| a.is_a?(Array) }}
end

def combine(seq)
  return seq if seq.is_a?(String)

  if special?(seq)
    return seq.map! { combine(_1) }.flatten!
  end
  return seq.map! { combine(_1) } if seq.flatten(1).find { _1.is_a?(Array) }
  return seq[1].map { seq[0] + _1 + seq[2] } if seq.size == 3
  return seq if seq.size > 2

  a, b = *seq
  if a.is_a?(String) && b.is_a?(Array)
    return b.map { a + _1 }
  end

  if a.is_a?(Array) && b.is_a?(String)
    return a.map { _1 + b }
  end

  if a.is_a?(Array) && b.is_a?(Array)
    return a.map do |ea|
      b.map do |eb|
        ea + eb
      end
    end.flatten
  end

  return seq if a.is_a?(String) && b.is_a?(String)

  binding.irb
end

valid = 0
combinations = []
DATA.each do |input|
  next parse_rules(input.chomp) if input.match?(/\d+:/)
  if input.chomp.empty?
    resolve_rules
    combinations = KNOWN[0]
    while combinations.find { _1.is_a?(Array) }
      p combinations
      combinations = combine(combinations)
    end
    p combinations
    p combinations.size
  end

  valid += 1 if combinations.include?(input)
end

p RULES
p KNOWN[0]
p combinations.size
p valid

__END__
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
