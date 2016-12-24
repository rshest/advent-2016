require 'digest'

class Keyer
  def initialize(seed, stretch=0)
    @keys = Hash.new do |hash, idx|
      s = seed + idx.to_s
      (stretch + 1).times.each {|*| s = Digest::MD5.hexdigest(s)}
      hash[idx] = s
    end
  end

  def is_valid_key(idx)
    key = @keys[idx]

    # find the 3-in-a-row character, if any
    cpos = key =~ /(.)\1\1/
    if cpos.nil? then return false end

    # check if next 1000 have it repeated 5 times
    pattern = (key[cpos]) * 5
    ((idx + 1)..(idx + 1000)).any? {|n| @keys[n].include? pattern}
  end

  def collect(amount)
    (0..Float::INFINITY).lazy
      .select {|x| is_valid_key(x)}.take(amount).to_a
  end
end

seed = File.read(ARGV[0] || "input.txt")

collector1 = Keyer.new(seed)
res1 = collector1.collect(64)
puts "Index for 64th key (stretch 0): #{res1[-1]}" 

collector2 = Keyer.new(seed, 2016)
res2 = collector2.collect(64)
puts "Index for 64th key (stretch 2016): #{res2[-1]}" 
