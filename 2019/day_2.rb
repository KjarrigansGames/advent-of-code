class Intcode
  def self.operate(data, pos = 0)
    opcode, op_a, op_b, target =*data[pos, 4]

    operation = case opcode
                when 1 then :+
                when 2 then :*
                when 99 then return data
                else raise "Invalid opcode: #{opcode}"
                end

    data[target] = data[op_a].send(operation, data[op_b])
    operate(data, pos + 4)
  end
end

100.times do |a|
  100.times do |b|
    s = Time.now
    data = Intcode.operate([1,a,b,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,13,19,1,10,19,23,2,9,23,27,1,6,27,31,1,10,31,35,1,35,10,39,1,9,39,43,1,6,43,47,1,10,47,51,1,6,51,55,2,13,55,59,1,6,59,63,1,10,63,67,2,67,9,71,1,71,5,75,1,13,75,79,2,79,13,83,1,83,9,87,2,10,87,91,2,91,6,95,2,13,95,99,1,10,99,103,2,9,103,107,1,107,5,111,2,9,111,115,1,5,115,119,1,9,119,123,2,123,6,127,1,5,127,131,1,10,131,135,1,135,6,139,1,139,5,143,1,143,9,147,1,5,147,151,1,151,13,155,1,5,155,159,1,2,159,163,1,163,6,0,99,2,0,14,0])
    if data[0] == 19690720
      p a
      p b
      p a * 100 + b
      break
    end
  end
end
