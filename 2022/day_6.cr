def start_of_packet(string, size = 4)
  string.size.times do |pos|
    marker = string[pos, size]
    return pos+size if marker.each_char.uniq.size == size
  end
end

p start_of_packet("mjqjpqmgbljsphdztnvjfqwrcgsmlb") == 7
p start_of_packet("bvwbjplbgvbhsrlpgdmjqwftvncz") == 5
p start_of_packet("nppdvjthqldpwncqszvftbrmjlhg") == 6
p start_of_packet("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg") == 10
p start_of_packet("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw") == 11

print "Part 1: "
p start_of_packet(File.read_lines("day_6.txt").first)

p start_of_packet("mjqjpqmgbljsphdztnvjfqwrcgsmlb", size: 14) == 19
p start_of_packet("bvwbjplbgvbhsrlpgdmjqwftvncz", size: 14) == 23
p start_of_packet("nppdvjthqldpwncqszvftbrmjlhg", size: 14) == 23
p start_of_packet("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", size: 14) == 29
p start_of_packet("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", size: 14) == 26

print "Part 2: "
p start_of_packet(File.read_lines("day_6.txt").first, size: 14)
