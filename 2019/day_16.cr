BASE_PATTERN = [0, 1, 0, -1]

def pattern(pos, idx)
  BASE_PATTERN[(pos % (4 * idx)) // idx]
end

def amplify(input, idx)
  sum = 0
  input[idx-1..-1].size.times do |pos|
    pos += (idx - 1)
    digit = input[pos]
    next if digit == "0"
    sum += digit.to_i * pattern(pos+1, idx)
  end
  sum.to_s[-1]
end

def phase(input)
  tmp = ""
  input.size.times do |idx|
    puts "#{idx}/#{input.size} done" if idx % 1_000 == 0
    tmp += amplify(input, idx+1)
  end
  tmp
end

def calc(signal : String, multiplier = 1)
  puts "Precompile input"
  signal = [signal] * multiplier
  signal = signal.flatten.join
  puts "Done (#{signal.size})"

  100.times do |idx|
    s = Time.local
    puts "Phase #{idx+1}..."
    signal = phase signal
    puts "took #{Time.local - s}s"
#     puts signal
    File.open("tmp2.tmp", "a+") do |f|
      f.print idx, ':'
      f.puts signal
    end
  end

  p signal[0,7]
  p signal[0,8]
#   raise "Wrong" unless signal[0,8] == "23845678"
  p signal[signal[0,7].to_i, 8]
end

calc(ARGV[1], ARGV[0].to_i)
