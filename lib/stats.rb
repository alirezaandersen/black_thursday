module Stats
  def self.average(nums)
    BigDecimal.new(nums.reduce(:+)/(nums.length.to_f),10)
  end

  def self.sample_variance(nums)
    mean = average(nums)
    sq_diffs = nums.reduce(0) do |sum, num|
      sum + (num-mean)**2
    end
    BigDecimal.new(sq_diffs/(nums.length-1),10)
  end

  def self.sample_std_dev(nums)
    BigDecimal.new(sample_variance(nums) ** 0.5, 10)
  end
end
