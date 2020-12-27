BASE_PATTERN = [0, 1, 0, -1]

def amp(idx, pos)
  BASE_PATTERN[(pos / idx) % 4]
end

10.times do |i|
  a = []
  10.times do |x|
    a << amp(i+1, x+1)
  end
  p a
end

raise "Wrong amp 1" unless amp(1, 1) == 1
raise "Wrong amp 1" unless amp(1, 2) == 0
raise "Wrong amp 1" unless amp(1, 3) == -1
raise "Wrong amp 1" unless amp(1, 4) == 0
raise "Wrong amp 1" unless amp(1, 5) == 1
raise "Wrong amp 1" unless amp(1, 6) == 0
raise "Wrong amp 1" unless amp(1, 7) == -1
raise "Wrong amp 1" unless amp(1, 8) == 0
raise "Wrong amp 1" unless amp(1, 9) == 1

raise "Wrong amp 2" unless amp(2, 1) == 0
raise "Wrong amp 2" unless amp(2, 2) == 1
raise "Wrong amp 2" unless amp(2, 3) == 1
raise "Wrong amp 2" unless amp(2, 4) == 0
raise "Wrong amp 2" unless amp(2, 5) == 0
raise "Wrong amp 2" unless amp(2, 6) == -1
raise "Wrong amp 2" unless amp(2, 7) == -1
raise "Wrong amp 2" unless amp(2, 8) == 0
raise "Wrong amp 2" unless amp(2, 9) == 0

raise "Wrong amp 3" unless amp(3, 1) == 0
raise "Wrong amp 3" unless amp(3, 2) == 0
raise "Wrong amp 3" unless amp(3, 3) == 1
raise "Wrong amp 3" unless amp(3, 4) == 1
raise "Wrong amp 3" unless amp(3, 5) == 1
raise "Wrong amp 3" unless amp(3, 6) == 0
raise "Wrong amp 3" unless amp(3, 7) == 0
raise "Wrong amp 3" unless amp(3, 8) == 0
raise "Wrong amp 3" unless amp(3, 9) == -1

def cycle(faktor = 1)
  list = []
  input = '59719811742386712072322509550573967421647565332667367184388997335292349852954113343804787102604664096288440135472284308373326245877593956199225516071210882728614292871131765110416999817460140955856338830118060988497097324334962543389288979535054141495171461720836525090700092901849537843081841755954360811618153200442803197286399570023355821961989595705705045742262477597293974158696594795118783767300148414702347570064139665680516053143032825288231685962359393267461932384683218413483205671636464298057303588424278653449749781937014234119757220011471950196190313903906218080178644004164122665292870495547666700781057929319060171363468213087408071790'
  input = input * faktor
  100.times do |phase|
    new_input = ''
    input.size.times do |idx|
      sum = []
      input.size.times do |pos|
        pos += idx
        break if pos == input.size
        sum << input[pos].to_i * amp(idx+1, pos+1)
      end
      new_input += sum.sum.to_s[-1]
    end
    input = new_input
    list << input[0,8]
  end
  list
end

binding.irb
