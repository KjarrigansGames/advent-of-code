SAMPLE ="[({(<(())[]>[[{[]{<()<>>
[(()[<>])]({[<{<<[]>>(
{([(<{}[<>[]}>{[]{[(<()>
(((({<>}<{<{<>}{[]{[]{}
[[<[([]))<([[{}[[()]]]
[{[{({}]{}}([{[{{{}}([]
{<[[]]>}<{[{[{[]{()[[[]
[<(<(<(<{}))><([]([]()
<{([([[(<>()){}]>(<<{{
<{([{{}}[<[[[<>{}]]]>[]]"

SYNTAX_SCORE = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

CLOSING_BRACKET = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>',
}

def parse_line(line)
  queue = [] of Char
  pos = 0
  line.chomp.each_char do |char|
    case char
    when '(', '[', '<', '{'
      # start of new chunk
      queue << char
    when ')', ']', '>', '}'
      if CLOSING_BRACKET[queue.last] == char
        queue.pop
      else
        return SYNTAX_SCORE[char]
      end
    else
      raise "Invalid character #{char.inspect}!"
    end
    pos += 1
  end

  return queue
end

def syntax_error_score(input)
  input.split("\n").map do |line|
    resp = parse_line(line)
    resp.is_a?(Int32) ? resp : 0
  end.sum
end


COMPLETION_SCORE = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4,
}
def completion_score(input)
  input.split("\n").map do |line|
    resp = parse_line(line)
    next if resp.is_a?(Int32)
    next if resp.empty?

    score : Int64 = 0
    resp.reverse_each do |char|
      score = score * 5 + COMPLETION_SCORE[char]
    end
    score
  end.compact.sort
end

print "Sample 26397 == "
puts syntax_error_score(SAMPLE)

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts syntax_error_score(input)

print "Sample 288957 == "
scores = completion_score(SAMPLE)
puts scores[(scores.size / 2).to_i32]


print "Part 2: "
scores = completion_score(input)
puts scores[(scores.size / 2).to_i32]
