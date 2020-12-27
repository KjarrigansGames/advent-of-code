require 'pmap'

BASE_PATTERN = [0, 1, 0, -1]

def pattern(pos, idx)
  BASE_PATTERN[pos % (4 * idx) / idx]
end

raise 'Wrong pattern generation' unless pattern(1,1) ==  1
raise 'Wrong pattern generation' unless pattern(2,1) ==  0
raise 'Wrong pattern generation' unless pattern(3,1) ==  -1
raise 'Wrong pattern generation' unless pattern(4,1) ==  0
raise 'Wrong pattern generation' unless pattern(5,1) ==  1
raise 'Wrong pattern generation' unless pattern(6,1) ==  0
raise 'Wrong pattern generation' unless pattern(7,1) ==  -1
raise 'Wrong pattern generation' unless pattern(8,1) ==  0
raise 'Wrong pattern generation' unless pattern(9,1) ==  1

raise 'Wrong pattern generation' unless pattern(1,2) ==  0
raise 'Wrong pattern generation' unless pattern(2,2) ==  1
raise 'Wrong pattern generation' unless pattern(3,2) ==  1
raise 'Wrong pattern generation' unless pattern(4,2) ==  0
raise 'Wrong pattern generation' unless pattern(5,2) ==  0
raise 'Wrong pattern generation' unless pattern(6,2) ==  -1
raise 'Wrong pattern generation' unless pattern(7,2) ==  -1
raise 'Wrong pattern generation' unless pattern(8,2) ==  0
raise 'Wrong pattern generation' unless pattern(9,2) ==  0
raise 'Wrong pattern generation' unless pattern(10,2) == 1

raise 'Wrong pattern generation' unless pattern(1,3) ==  0
raise 'Wrong pattern generation' unless pattern(2,3) ==  0
raise 'Wrong pattern generation' unless pattern(3,3) ==  1
raise 'Wrong pattern generation' unless pattern(4,3) ==  1
raise 'Wrong pattern generation' unless pattern(5,3) ==  1
raise 'Wrong pattern generation' unless pattern(6,3) ==  0
raise 'Wrong pattern generation' unless pattern(7,3) ==  0
raise 'Wrong pattern generation' unless pattern(8,3) ==  0
raise 'Wrong pattern generation' unless pattern(9,3) ==  -1
raise 'Wrong pattern generation' unless pattern(10,3) == -1

def amplify(input, idx)
  val = input.chars.map.with_index(1) do |digit, pos|
    digit.to_i * pattern(pos, idx)
  end.sum.to_s[-1, 1]
  val
end

def phase(input)
  tmp = ''
  input.size.times do |idx|
    print "Number...#{idx}"
    tmp += amplify(input, idx+1)
  end
  tmp
end

signal = '59719811742386712072322509550573967421647565332667367184388997335292349852954113343804787102604664096288440135472284308373326245877593956199225516071210882728614292871131765110416999817460140955856338830118060988497097324334962543389288979535054141495171461720836525090700092901849537843081841755954360811618153200442803197286399570023355821961989595705705045742262477597293974158696594795118783767300148414702347570064139665680516053143032825288231685962359393267461932384683218413483205671636464298057303588424278653449749781937014234119757220011471950196190313903906218080178644004164122665292870495547666700781057929319060171363468213087408071790'

raise "Base operation invalid" unless phase('12345678') == '48226158'

puts 'Precompile input'
signal = [signal] #  * 50
signal = signal.flatten.join
puts "Done (#{signal.size})"

100.times do |idx|
  s = Time.now
  print "Phase #{idx+1}..."
  signal = phase signal
  puts "took #{Time.now - s}s"
end

p signal[0,8]
p signal[signal[0,7].to_i, 8]

binding.irb
