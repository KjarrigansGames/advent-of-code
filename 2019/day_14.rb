class Nanofactory
  attr_reader :receipts
  attr_reader :resources
  attr_reader :output_multiplier
  def initialize(formulas)
    @receipts = {}
    @resources = Hash.new(0)
    @output_multiplier = Hash.new(1)
    formulas.each { |rec| parse_receipt(rec.chomp) }
  end

  def produce(type, amount = 1, external_input: 'ORE', external_amount: 0)
    until resources[type] >= amount
      receipts[type].call
    end
    p 'pre generation done'

    # Now we just loop until all resources are >= 0
    loop do
#       binding.irb
      p resources[external_input].abs
      #receipts[type].call if resources[external_input].abs <= external_amount

      break unless resources.find do |typ, qty|
        if typ == external_input
          false
        else
          qty.negative?
        end
      end

      resources.dup.each do |type, amount|
        next if type == external_input
        next if amount >= 0

        receipts[type].call(amount.abs)
        p "#{type} done"
      end
    end
  end

  private

  def parse_receipt(string)
    input, output = string.tr(' ', '').split('=>')
    input = input.split(',').map do |tuple|
      _, amount, type = tuple.split(/(\d+)/)
      lambda {|multiplier=1| @resources[type] -= (multiplier * amount.to_i)}
    end

    _, amount, type = output.split(/(\d+)/)

    @output_multiplier[type] = amount
    receipts[type] = lambda do |multi=1|
      multiplier = (multi / @output_multiplier[type].to_f).ceil
      input.each{|a| a.call(multiplier) }
      @resources[type] += (multiplier * amount.to_i)
    end
  rescue => err
    binding.irb
  end
end

nano = Nanofactory.new DATA.readlines
# binding.irb

# cargo = 1_000_000_000_000
# fuel = 0
# nano.produce 'FUEL', 1, external_amount: cargo
#   break if cargo <= nano.resources['ORE'].abs
#
#   p nano.resources['ORE'].abs
#   fuel += 1
# end

# require 'irb'
binding.irb

__END__
1 FVBHS, 29 HWPND => 4 CPXDX
5 TNWDG, 69 VZMS, 1 GXSD, 48 NCLZ, 3 RSRZ, 15 HWPND, 25 SGPK, 2 SVCQ => 1 FUEL
1 PQRLB, 1 TWPMQ => 4 QBXC
9 QBXC => 7 RNHQ
12 VZMS => 6 MGQRZ
6 QBVG, 10 XJWX => 6 BWLZ
4 MVGN => 6 BHZH
2 LKTWD => 7 FVBHS
2 BWFK => 7 TFPQ
15 VZBJ, 9 TSVN, 2 BWLZ => 2 TNWDG
10 KVFL, 2 BWLZ, 1 VGSBF => 4 KBFJV
12 TXCR, 2 JMBG => 4 DCFD
5 VMDT, 6 JKPFT, 3 RJKJD => 7 LGWM
1 LDFGW => 2 DHRBP
129 ORE => 8 LDFGW
9 DNVRJ => 8 BMNGX
7 NLPB => 6 NCLZ
1 VMDT, 6 DCFD => 9 SGRXC
1 LDFGW, 2 VRHFB => 8 QHGQC
10 VGSBF, 5 WVMG, 6 BWLZ => 3 BWFK
4 KVFL, 1 TSVN => 6 SVCQ
2 VZBJ, 3 SWJZ => 3 QZLC
5 JMBG, 1 PQRLB => 3 CJLH
13 LKTWD, 6 TFPQ => 3 WVRXR
20 QHGQC, 10 NSPVD => 5 VGSBF
5 TFPQ, 1 DHRBP, 2 KVFL => 8 NLPB
2 KBFJV, 1 CJLH, 20 RNHQ, 1 BWLZ, 13 MNBK, 1 BHZH, 1 PKRJF => 8 RSRZ
154 ORE => 2 VRHFB
2 NHRCK => 7 DNVRJ
2 VRHFB, 4 XJWX => 4 NHRCK
1 TFPQ, 12 JMBG => 5 MNBK
8 TMFS => 2 VZMS
175 ORE => 2 TMFS
1 LBZN, 2 SWJZ, 3 VGSBF => 8 BLDN
7 KFJD, 5 WVRXR, 5 RJKJD => 6 MVGN
3 RJKJD, 1 TXCR => 8 KVFL
3 QHGQC, 1 MGQRZ, 10 VGSBF => 8 LKTWD
178 ORE => 1 XJWX
1 QBXC, 1 BWFK => 6 TSVN
1 NHRCK, 2 DHRBP => 4 VZBJ
1 LDFGW, 2 NHRCK, 10 BWLZ => 8 TWPMQ
28 TWPMQ => 4 RJKJD
10 SVCQ, 1 KVFL => 6 CZNMG
3 VZMS, 3 MGQRZ => 3 WVMG
19 MGQRZ => 8 KFJD
3 WVMG => 6 PQRLB
31 SVCQ, 1 TXCR => 8 VMDT
20 KFJD, 5 CPXDX, 2 BLDN, 2 PQWJX, 12 TFPQ, 2 BHZH, 2 MVGN => 9 SGPK
7 QZLC => 8 JMBG
1 PQRLB => 1 HWPND
9 VMDT, 5 CZNMG, 3 CPXDX, 1 MVGN, 8 VSMTK, 2 SGRXC, 1 MNBK, 8 LGWM => 7 GXSD
2 NSPVD => 8 QBVG
20 CZNMG => 4 PQWJX
1 LDFGW => 4 NSPVD
16 KBFJV, 22 BLDN => 2 VSMTK
10 BWLZ => 9 LBZN
1 BWLZ => 3 SWJZ
1 HWPND => 9 TXCR
12 CJLH, 9 LGWM, 3 BHZH => 6 PKRJF
5 BMNGX => 7 JKPFT
