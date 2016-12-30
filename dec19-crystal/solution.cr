


# A "formula" solution to Part 1.
# The winner is whoever "starts" the round.
def make_round1(n, start=1, step=1)
  if n <= 2
    return start
  end
  step2 = step*2
  n2 = n/2
  start2 = (n%2 == 0) ? start : start + step2
  return make_round1(n2, start2, step2)
end

fname = ARGV.size > 0 ? ARGV[0] : "input.txt"
num = File.read(fname).to_i
puts "Winner in the Round 1: #{make_round1(num)}"
