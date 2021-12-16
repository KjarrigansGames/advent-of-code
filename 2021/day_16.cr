struct Package
  property version : Int32, type : Int32
  property payload
  setter value : Int64
  def initialize(@version : Int32, @type : Int32, @value = 0i64, @payload = Array(Package).new)
  end

  def value
    case type
    when 0
      payload.sum { |pack| pack.value.as(Int64)  }
    when 1
      payload.map { |pack| pack.value.as(Int64) }.reduce { |a,b| a * b }
    when 2
      payload.map { |pack| pack.value.as(Int64) }.min
    when 3
      payload.map { |pack| pack.value.as(Int64) }.max
    when 4
      @value
    when 5
      if payload.size != 2
        puts "Invalid packet: #{self}"
        # raise "Invalid packet: #{self}"
        return 0i64
      end

      payload[0].value > payload[1].value ? 1i64 : 0i64
    when 6
      if payload.size != 2
        puts "Invalid packet: #{self}"
        # raise "Invalid packet: #{self}"
        return 0i64
      end

      payload[0].value < payload[1].value ? 1i64 : 0i64
    when 7
      if payload.size != 2
        puts "Invalid packet: #{self}"
        # raise "Invalid packet: #{self}"
        return 0i64
      end

      payload[0].value == payload[1].value ? 1i64 : 0i64
    else
      raise "Invalid Type #{self}"
    end
  end
end

class Parser
  property pos = 0
  property bitstring = ""
  property debug = false

  def initialize(string, @debug = false)
    string.each_char do |char|
      @bitstring += char.to_i(16).to_s(2).rjust(4, '0')
    end
  end

  # The input is "reasonably" short so we can convert the whole thing "in memory" to a bit string
  def read_int(len, message="")
    print_pos(message)
    resp = bitstring[@pos, len]
    @pos += len
    resp.to_i(2)
  end

  def print_pos(message = "", chars_per_line=120)
    return unless @debug

    ((bitstring.size / chars_per_line).to_i32 + 1).times do |chunk|
      offset = chunk*chars_per_line
      puts bitstring[offset, chars_per_line]
      if @pos >= offset && @pos < offset+chars_per_line
        print " " * (@pos % chars_per_line)
        puts "^ Pos: #{@pos}/#{bitstring.size} #{message}"
        return
      end
    end
  end

  def read_literal_value
    payload = ""
    last_package = false
    until last_package
      print_pos("value")
      payload += bitstring[pos+1, 4]
      last_package = bitstring[@pos] == '0'
      @pos += 5
    end
    payload.to_i64(2)
  end

  def run
    current = Package.new(read_int(3, :version), read_int(3, :type))
    case current.type
    when 4
      current.value = read_literal_value
    else
      # Operator Packet
      payload_mode = read_int(1, :len_id)
      if payload_mode == 0
        payload_length = read_int(15, :payload_length)
        start_pos = @pos
        until @pos >= start_pos + payload_length
          current.payload << run
        end
      else
        payload_count = read_int(11, :payload_length)
        until current.payload.size == payload_count
          current.payload << run
        end
      end
    end
    current
  end
end

def version_sum(package)
  sum = package.version
  package.payload.each do |pack|
    sum += version_sum(pack)
  end
  sum
end

def part1(input, debug=false)
  puts if debug

  pack = Parser.new(input, debug: debug).run
  p pack if debug
  version_sum(pack)
end

def part2(input)
  Parser.new(input).run.value
end

pars = Parser.new("D2FE28")
print "Sample 2021 == "
puts pars.run.value

print "Sample 30 == "
pars = Parser.new("38006F45291200")
puts pars.run.payload.sum { |pl| pl.value }

print "Sample 16 == "
puts part1("8A004A801A8002F478")

print "Sample 12 == "
puts part1("620080001611562C8802118E34")

print "Sample 23 == "
puts part1("C0015000016115A2E0802F182340")

print "Sample 31 == "
puts part1("A0016C880162017C3686B18A3D4780")

input = File.read(File.expand_path(__FILE__).gsub(".cr", ".txt")).chomp
print "Part 1: "
puts part1(input)

print "Sample 1 == "
puts part2("9C0141080250320F1802104A08")

print "Part 2: "
puts part2(input)
