adapters = DATA.readlines.map{ _1.chomp.to_i }
adapters << 0
adapters << adapters.max + 3
adapters.sort!

def part_1(adapters)
  delta_jolt = Hash.new(0)
  adapters.sort.each_cons(2) do |a, b|
    delta_jolt[b - a] += 1
  end
  print "Part 1: "
  p delta_jolt[1] * delta_jolt[3]
end

# def part_2(adapters)
#   binding.irb
#   return 0 if adapters.size < 10
#   p "Checking (#{adapters[0,3].join(',')}..#{adapters[-3,3].join(',')}) - #{adapters.size}"
#   counter = 0
#   counter += 1 if adapters.each_cons(2) do |a,b|
#     break false if b-a > 3
#     if b-a < 3 && a > 0
#       rek = adapters.dup
#       rek.delete(a)
#       counter += part_2(rek)
#     end
#   end
#   counter
# end

def part_2(adapters)
  seq = Hash.new(0)
  current_streak = 0
  adapters.each_cons(2) do |a,b|
    next current_streak += 1 if b - a == 1

    seq[current_streak] += 1
    current_streak = 0
  end
  print 'Part 2: '
  puts 7**seq[4] * 4**seq[3] * 2**seq[2]
end

part_1 adapters
part_2 adapters

# binding.irb
# part_2 adapters
# 0 1 2 <- 2
# 5 6
# 9 10 11 12 13 <- 7
# 16
# 19 20 21 22 23 <- 7
# 26 27 28 29 30 <- 7
# 33 34 35 36 37  <- 7
# 40 41 42 43 <- 4
# 46 47 48 <- 2
# 51 54 55
# 58 59
# 62 63 64 65 <-4
# 68 69 70 <- 2
# 73
# 76 77 78 <- 2
# 81 82 83 84 <- 4
# 87
# 90 91 92 93 94 <- 7
# 97 98 99 100 <- 4
# 103
# 106 107 108 109 <- 4
# 112 113 114 115 116 <- 7
# 119 120 121 122 123 <- 7
# 126 127 128 129 <- 4
# 132 133 134 135 <- 4
# 138 139 140 141 142 <- 7
# 145 146 147 148 149 <- 7
# 152
#
# 0  1  2  3  4 | 4
# 7  8  9 10 11 | 4
# 14
# 17 18 19 20 | 3
# 23 24 25 | 2
# 28
# 31 32 33 34 35 | 4
# 38 39 42
# 45 46 47 48 49 | 4
# 52

__END__
71
30
134
33
51
115
122
38
61
103
21
12
44
129
29
89
54
83
96
91
133
102
99
52
144
82
22
68
7
15
93
125
14
92
1
146
67
132
114
59
72
107
34
119
136
60
20
53
8
46
55
26
126
77
65
78
13
108
142
27
75
110
90
35
143
86
116
79
48
113
101
2
123
58
19
76
16
66
135
64
28
9
6
100
124
47
109
23
139
145
5
45
106
41
