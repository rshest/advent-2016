
class Elf
  @right : self|Nil = nil
  @left  : self|Nil = nil

  def initialize(@index : Int32) end

  getter right
  setter right

  getter left
  setter left

  getter index
end


# A "formula" solution to Part 1.
# The winner is whoever "starts" the round.
def make_round1(n, start=1, step=1)
  return start if n <= 2
  n2, step2 = n/2, step*2
  start2 = (n%2 == 0) ? start : start + step2
  make_round1 n2, start2, step2
end


# For Part 2 we simulate the whole thing, because it's not easy 
# to come up with a formula anymore
def make_round2(n)
  elves = Array.new(n) { |i| Elf.new(i + 1) }
  elves.each do |elf| 
    elf.right = elves[(elf.index + n - 2)%n]
    elf.left = elves[(elf.index)%n]
  end

  cur_elf = elves[0]
  steal_from : Elf = cur_elf.left.not_nil!
  (1...(n/2)).each { |_| steal_from = steal_from.left.not_nil! }
  k = n
  while k > 1
    steal_from.left.not_nil!.right = steal_from.right
    steal_from.right.not_nil!.left = steal_from.left
    steal_from = steal_from.left.not_nil!
    cur_elf = cur_elf.not_nil!.left
    k -= 1
    if k%2 == 0
      steal_from = steal_from.left.not_nil!
    end
  end
  cur_elf.not_nil!.index
end


fname = ARGV.size > 0 ? ARGV[0] : "input.txt"
num = File.read(fname).to_i
puts "Winner in the Round 1: #{make_round1(num)}"
puts "Winner in the Round 2: #{make_round2(num)}"
